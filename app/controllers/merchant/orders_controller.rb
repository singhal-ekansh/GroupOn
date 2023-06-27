class Merchant::OrdersController < ApplicationController

  before_action :set_deal, only: :index

  def index
    @orders =  @deal.orders.includes(:deal).order(created_at: :desc).paginate(page: params[:page])
  end

  private def set_deal
    @deal = Deal.find_by(id: params[:deal_id])
    redirect_to root_path, alert: 'invalid deal' if !@deal
  end
end