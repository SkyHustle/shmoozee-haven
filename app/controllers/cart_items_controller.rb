class CartItemsController < ApplicationController
  include ActionView::Helpers::TextHelper
  skip_before_action :verify_authenticity_token

  def create
    item = Item.find(params[:item_id])
    item_quantity = params[:quantity]
    @cart.add_item(item.id, item_quantity)
    session[:cart] = @cart.contents
    flash[:notice] = "You now have #{pluralize(@cart.count_of(item.id), item.title)}."
    redirect_to :back
  end

  def destroy
    session[:cart].delete(params[:id])
    if @cart.contents.empty?
      flash[:notice] = "Your Cart Is Empty, Go Fill It Up!"
      redirect_to root_path
    else
      redirect_to :back
    end
  end
end