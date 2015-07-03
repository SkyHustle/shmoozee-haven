require 'rails_helper'

RSpec.feature 'the unauthenticated user' do
  let!(:category) { Category.create!(name: "Fruit") }
  let!(:item)     { Item.create!(title: "Apricot", description: "it's orange", price: 2.00) }
  let!(:category_item) { CategoryItem.create(item_id: item.id, category_id: category.id) }

  scenario "can add an item with a category to its cart" do
    visit root_path

    expect(current_path).to eq(root_path)

    click_link(category.name)

    click_button("Add To Cart")

    page.find('.cart > a').click

    expect(current_path).to eq(cart_path)

    expect(page).to have_content(category.items.first.title)
    expect(page).to have_content(category.items.first.description)
    expect(page).to have_content("1") #Quantity

    expect(page).to have_content(item.categories.first.name)
  end

  scenario "can clear all items from its cart" do
    visit category_path(category.id)

    click_button("Add To Cart")

    page.find('.cart > a').click

    expect(page).to have_content(item.title)
    expect(page).to have_content(item.price)

    page.find('.alert').click

    expect(page).to_not have_content(item.title)
  end

  scenario "can add multiple quantities of an item to a cart" do
    visit category_path(category.id)

    fill_in 'quantity', with: '5'

    click_button("Add To Cart")

    expect(page).to have_content('5')
    expect(page).to_not have_content('1')

    visit cart_path
    expect(page).to have_content('5')
    expect(page).to_not have_content('1')
  end

  scenario "can update item quantity before checking out" do
    visit category_path(category.id)

    fill_in 'quantity', with: '5'

    click_button("Add To Cart")

    visit cart_path

    expect(page).to have_content('5')

    fill_in 'quantity', with: '3'

    page.find('.update').click

    expect(page).to_not have_content('5')
    expect(page).to have_content('3')
  end

  scenario "can remove a single item from its cart" do
  end

  scenario "cannot checkout" do

  end
end