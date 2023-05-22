class Admin::DealsController < ApplicationController

  def new
    @deal = Deal.new
    @deal.locations.build
  end

  def create
    debugger
    @deal = Deal.new(deal_params)
    if @deal.save
    end
  end

  private def deal_params
    params.require(:deal).permit(:title, :description, :threshold_value, :total_availaible, :price, :start_at,
       :expire_at, :max_per_user, :category_id, :published, images: [],
        location_attributes: Location.attribute_names.map(&:to_sym).push(:_destroy))
  end
end