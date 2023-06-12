class DealsController < ApplicationController
  before_action :authenticate
  before_action :set_deal, only: [:show]

  before_action :authenticate

  def index
    @deals = Deal.includes(:likes, :deal_images, :locations).published.live
    @likes_count = @deals.joins(:likes).published.live.group(:id).sum('likes.liked = true')
    @dislikes_count = @deals.joins(:likes).published.live.group(:id).sum('likes.liked = false')
    
    if !params[:query].blank?
      query = "%#{params[:query]}%"
      @deals = @deals.where("title LIKE ? OR locations.city LIKE ?", query, query).references(:locations)
    end
    
    if !params[:category].blank?
      @deals = @deals.where(category_id: params[:category])
    end
  end

  def show
  end

  def like
    @deal = Deal.find_by(id: params[:deal_id])
    return if !@deal

    @like = Like.find_or_initialize_by(deal: @deal, user: @current_user)
    @like.liked = params[:value]

    if !@like.liked_changed? || !@like.save
      @like.destroy
    end
    redirect_back fallback_location: deals_path
      
  end

  def expired_deals

    @deals = Deal.includes(:likes, :deal_images, :locations).published.expired
    @likes_count = Deal.joins(:likes).published.expired.group(:id).sum('likes.liked = true')
    @dislikes_count = Deal.joins(:likes).published.expired.group(:id).sum('likes.liked = false')
    
    if !params[:query].blank?
      query = "%#{params[:query]}%"
      @deals = @deals.where("title LIKE ? OR locations.city LIKE ?", query, query).references(:locations)
    end
    if !params[:category].blank?
      @deals = @deals.where(category_id: params[:category])
    end
  end

  def set_deal
    @deal = Deal.find_by(id: params[:id])
    redirect_to deals_path, alert: 'invalid deal' if !@deal
  end
end