class Admin::ReportsController < ApplicationController

  def index
    @top_customers = User.most_spenders
    if params[:start_at].blank? || params[:end_at].blank?
      @top_deals = Deal.most_revenue
    else
      @top_deals = Deal.most_revenue(params[:start_at], params[:end_at])
    end
    @top_categories = Category.popular

    @spend_max_with_max_amount_20 = User.joins(:orders).where(orders: {status: :processed, created_at: 1.month.ago..}).group(:id).having('MAX(orders.amount)
    <= 20').order('SUM(orders.amount) DESC').select(:id, :first_name, :last_name, 'SUM(orders.amount) as spending').limit(5)

    @users_reviewed_deal_processed_last_month = User.joins(:reviewed_deals).where(deals: {expire_at: 1.month.ago..} ).where('qty_sold >= threshold_value').select(:id, :first_name, :last_name).distinct
    
    @merchant_deal_processed_with_pics_likes_reviews = User.joins(merchant_deals: [:images, :likes, :reviews]).where(likes: {is_liked: true}, deals: {expire_at: ..Date.today}).select(:id, :first_name, :last_name).where('qty_sold >= threshold_value').group(:id).having('Count(DISTINCT images.id) > 2').having('Sum(DISTINCT likes.id) > 10').having('count(DISTINCT reviews.id) > 5')

    @most_disliked_deal_order_value_100 = Deal.joins(:likes).where(likes: {is_liked: false}).where('qty_sold * price = 100').select(:title, 'count(likes.id) as dislikes').group(:id).order('count(likes.id) desc').limit(1)

    @most_liked_category = Category.joins(deals: :likes).where(deals: {expire_at: ..Date.today}, likes: {is_liked: true}).select(:name, 'count(likes.id) as likes').where('qty_sold >= threshold_value').group(:id).order('count(likes.id) desc')


  end
end