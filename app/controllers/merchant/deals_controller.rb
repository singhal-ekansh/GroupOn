class Merchant::DealsController < ApplicationController

  before_action :set_deal, only: :show

  def index
    @deals = Deal.includes(:deal_images).published.where(merchant: current_user).paginate(page: params[:page])
  end

  def show
  end

  private def set_deal
    @deal = Deal.find_by(id: params[:id])
    redirect_to root_url, alert: 'invalid deal' if !@deal
  end
end