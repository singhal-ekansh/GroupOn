class CouponsController < ApplicationController
  before_action :authenticate

  def index
    @coupons = Coupon.includes(order: :deal).where(order: {user: current_user})
  end
end