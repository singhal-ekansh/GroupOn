class Merchant::CouponsController < Merchant::BaseController
  
  before_action :set_deal, only: :index

  def index
    @coupons = @deal.coupons
  end

  def redeem_coupons
  end

  def redeem
    coupon = Coupon.find_by(code: params[:coupon_code])
    if coupon && !coupon.redeemed_at && coupon.order.deal.merchant == current_user
      coupon.update(redeemed_at: Time.now)
      redirect_to merchant_deal_path(coupon.order.deal), notice: 'Coupon Redeemed'
    else
      flash.now[:alert] = 'Invalid Coupon'
      render :redeem_coupons
    end
    
  end

  private def set_deal
    @deal = Deal.find_by(id: params[:deal_id])
    redirect_to root_path, alert: 'invalid deal' if !@deal
  end
end