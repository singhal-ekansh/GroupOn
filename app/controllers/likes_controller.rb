class LikesController < ApplicationController
  before_action :authenticate
  before_action :set_object, only: [:create, :update, :destroy]
  before_action :set_like, only: [:update, :destroy]

  def create
    @like = current_user.likes.build(likable: @object, is_liked: params[:value])

    if @like.save
      redirect_back fallback_location: root_url
    end
  end

  def update
    if @like.update(is_liked: params[:value])
      redirect_back fallback_location: root_url
    end
  end

  def destroy
    if @like.destroy
      redirect_back fallback_location: root_url
    end
  end

  private def set_object
    @object = Deal.find_by(id: params[:deal_id]) if params[:deal_id]
    redirect_back fallback_location: root_url unless @object
  end

  private def set_like
    @like = current_user.likes.find_by(likable: @object)
    redirect_back fallback_location: root_url unless @like
  end

end