class OrdersController < ApplicationController
  before_action :authenticate
  before_action :set_deal, only: [:new, :create]
  before_action :set_order, only: [:payment_success, :payment_failed]

  def new
    @order = Order.new
  end

  def index
    @orders = current_user.orders.order(created_at: :desc).paginate(page: params[:page])
  end

  def create
    @order = Order.new(deal: @deal, user:  current_user, quantity: params[:order][:quantity])

    Order.transaction do 
      if @order.save
        checkout_service = StripeCheckoutService.new(payment_success_orders_url(order_id: @order.id), payment_failed_orders_url(order_id: @order.id), @order)
        if checkout_service.call
          redirect_to checkout_service.get_stripe_url, allow_other_host: true
        else
          flash.now[:alert] = 'error occured'
          render :new
        end
      else
        render :new
      end
    end
  end

  def payment_success
    transaction = @order.payment_transactions.find_by(status: :pending)
    if transaction&.update(status: :paid)
      flash[:notice] = "Order placed"
    else
      flash[:notice] = "payment failed"
    end 
    redirect_to orders_path
  end

  def payment_failed
    @order.payment_transactions.find_by(status: :pending)&.update(status: :failed)
    redirect_to orders_path, alert: "payment failed"
  end

  private def set_deal
    @deal = Deal.find_by(id: params[:deal_id])
    redirect_to deals_path, alert: 'invalid deal' if !@deal
  end

  private def set_order
    @order = Order.find_by(id: params[:order_id])
    redirect_to deals_path, alert: 'invalid order' if !@order
  end

end