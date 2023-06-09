class Merchant::DealsController < ApplicationController
  before_action :authenticate
  before_action :ensure_merchant

  def index
    @deals = Deal.includes(:deal_images).published.where(merchant: current_user).paginate(page: params[:page], per_page: DEAL_PER_PAGE)
  end

  def show
    @deal = Deal.find_by(id: params[:id])
  end

end