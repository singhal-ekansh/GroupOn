class ReviewsController < ApplicationController

  before_action :set_object

  def create
    review = current_user.reviews.build(body: params[:review_body], reviewable: @object)

    if review.save
      redirect_back_or_to root_url
    end
  end

  def set_object
    @object = Deal.find_by(id: params[:deal_id])
    redirect_to root_path if !@object
  end
  
end