class Admin::ReportsController < ApplicationController

  def index
    @top_customers = User.most_spenders
    if params[:start_at].blank? || params[:end_at].blank?
      @top_deals = Deal.most_revenue
    else
      @top_deals = Deal.most_revenue(params[:start_at], params[:end_at])
    end
    @top_categories = Category.popular
  end
end