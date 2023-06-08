class Admin::ReportsController < ApplicationController

  def index
    @top_customers = User.most_spenders
    @top_deals = Deal.most_revenue
    @top_categories = Category.popular
  end

  def filter_deal
    @top_customers = User.most_spenders
    @top_deals = Deal.most_revenue(params[:start_at], params[:end_at])
    @top_categories = Category.popular
    render 'index'
  end
end