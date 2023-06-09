class Merchant::CouponsController < ApplicationController
  before_action :authenticate
  before_action :ensure_merchant

  def index
    @coupons = Coupon.includes(order: :deal).where(order: {deal_id: params[:deal_id]})
  end

  def redeem_coupons
  end

  def redeem
    coupon = Coupon.find_by(code: params[:coupon_code])
    if coupon && !coupon.redeemed_at && coupon.order.deal.merchant == current_user
      coupon.update_columns(redeemed_at: Time.now)
      redirect_to merchant_deal_path(coupon.order.deal), notice: 'Coupon Redeemed'
    else
      flash.now[:alert] = 'Invalid Coupon'
      render :redeem_coupons
    end
    
  end
end