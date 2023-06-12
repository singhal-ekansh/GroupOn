class DealsController < ApplicationController

  def index
    @deals = Deal.includes(:likes, :deal_images, :locations).published.live
    
    unless params[:query].blank?
      query = "%#{params[:query]}%"
      @deals = @deals.where("title LIKE ? OR locations.city LIKE ?", query, query).references(:locations)
    end
    
    unless params[:category].blank?
      @deals = @deals.where(category_id: params[:category])
    end
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

  def expired_deals

    @deals = Deal.includes(:likes, :deal_images, :locations).published.expired
    
    unless params[:query].blank?
      query = "%#{params[:query]}%"
      @deals = @deals.where("title LIKE ? OR locations.city LIKE ?", query, query).references(:locations)
    end
    unless params[:category].blank?
      @deals = @deals.where(category_id: params[:category])
    end
  end
end