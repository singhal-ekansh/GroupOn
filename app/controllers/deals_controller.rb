class DealsController < ApplicationController

  def index
    @deals = Deal.includes(:likes)
  end

  def show
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
end