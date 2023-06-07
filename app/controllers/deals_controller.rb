class DealsController < ApplicationController

  def index
    @deals = Deal.published.includes(:likes, :deal_images)
  end

  def show
    @deal = Deal.find_by(id: params[:id])
  end

  def like
    @deal = Deal.find_by(id: params[:deal_id])
    return unless @deal

    @like = Like.find_or_initialize_by(deal: @deal, user: @current_user)
    @like.liked = params[:value]

    unless @like.liked_changed? && @like.save
      @like.destroy
    end
    redirect_to deals_path
      
  end

  def search
    query = "%#{params[:query]}%"
    @deals = Deal.published.includes(:likes, :deal_images).joins(:locations).where("title LIKE ? OR locations.city LIKE ?", query, query)
    render "index"
  end

  def filter
    if params[:category].blank?
      @deals = Deal.published.includes(:likes, :deal_images)    
    else
      @deals = Deal.published.includes(:likes, :deal_images).where(category_id: params[:category])
    end
    render "index"
  end
end