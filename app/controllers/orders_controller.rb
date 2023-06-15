class OrdersController < ApplicationController
  before_action :authenticate
  before_action :set_deal, only: [:new, :create]
  before_action :set_order, only: [:placed, :failed]

  def new
    @order = Order.new
  end

  def index
    @orders = Order.where(user: current_user).order(created_at: :desc)
  end

  def create
    @order = Order.new(deal: @deal, user:  current_user, quantity: params[:order][:quantity])

    if @order.save
      checkout_service = StripeCheckoutService.new(current_user, order_success_url(order_id: @order.id), order_failed_url(order_id: @order.id), @order)
      checkout_service.generate_payment
      redirect_to checkout_service.get_stripe_url, allow_other_host: true
    else
      render :new
    end
  end

  def placed
    @order.payment_transactions.find_by(status: :pending)&.update(status: :paid)
    redirect_to orders_path, notice: "Order placed"
  end

  def failed
    @order.payment_transactions.find_by(status: :pending)&.update(status: :failed)
    redirect_to orders_path, alert: "payment failed"
  end

  private def set_deal
    @deal = Deal.find_by(id: params[:deal_id])
    redirect_to deals_path, alert: 'invalid deal' if !@deal
  end

  private def set_order
    @order = Order.find_by(id: params[:order_id])
  end

end