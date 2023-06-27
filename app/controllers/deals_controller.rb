class DealsController < ApplicationController
  before_action :authenticate
  before_action :set_deal, only: [:show]
  before_action :set_like_dislike_count, only: [:index, :expired_deals, :search]

  def index
    @deals = Deal.includes([images: [file_attachment: :blob]]).published.live.paginate(page: params[:page])
  end

  def show
  end

  def expired_deals
    @deals = Deal.includes([images: [file_attachment: :blob]]).published.expired.paginate(page: params[:page])
  end

  def search
    @deals = Deal.includes([images: [file_attachment: :blob]]).joins(:locations).published.paginate(page: params[:page]).distinct
    @deals = params[:deal_type] == 'live' ? @deals.live : @deals.expired

    @deals = @deals.search_by_city_and_title("%#{Deal.sanitize_sql_like(params[:query])}%") if !params[:query].blank?
    @deals = @deals.filter_by_category(params[:category]) if !params[:category].blank?

    render params[:deal_type] == 'live' ? :index : :expired_deals
  end

  private def set_like_dislike_count
    @likes_count = Deal.joins(:likes).published.group(:id).sum('likes.is_liked = true')
    @dislikes_count = Deal.joins(:likes).published.group(:id).sum('likes.is_liked = false')
    @user_likes_dislikes = current_user.likes.where(likable_type: 'Deal').pluck(:likable_id, :is_liked).to_h
  end

  private def set_deal
    @deal = Deal.includes([images: [file_attachment: :blob]]).find_by(id: params[:id])
    redirect_to deals_path, alert: 'invalid deal' if !@deal
  end
end