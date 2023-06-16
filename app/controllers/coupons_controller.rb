class CouponsController < ApplicationController
  before_action :authenticate

  def index
    @coupons = current_user.coupons.includes(order: :deal)
  end
end