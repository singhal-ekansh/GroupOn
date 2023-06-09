class Merchant::OrdersController < ApplicationController
  def index
    @orders = Order.where(deal_id: params[:deal_id]).order(created_at: :desc).paginate(page: params[:page], per_page: ORDER_PER_PAGE)
  end
end