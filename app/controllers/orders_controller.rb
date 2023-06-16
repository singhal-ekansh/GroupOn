class OrdersController < ApplicationController
  before_action :authenticate
  before_action :set_deal, only: [:new, :create]
  before_action :set_order, only: [:placed, :failed]

  def new
    @order = Order.new
  end

  def index
<<<<<<< HEAD
    @orders = Order.where(user: current_user).order(created_at: :desc).paginate(page: params[:page])
=======
    @orders = current_user.orders.order(created_at: :desc)
>>>>>>> order_process_jobs
  end

  def create
    @order = Order.new(deal: @deal, user:  current_user, quantity: params[:order][:quantity])

    if @order.save
<<<<<<< HEAD
      ActionCable.server.broadcast('deals_channel', {deal_id: @deal.id, qty: @deal.total_availaible - @deal.qty_sold })
      ActionCable.server.broadcast('deals_channel', {deal_id: @deal.id, qty: @deal.total_availaible - @deal.qty_sold })
      checkout_service = StripeCheckoutService.new(current_user, order_success_url(order_id: @order.id), order_failed_url(order_id: @order.id), @order)
      checkout_service.generate_payment
      redirect_to checkout_service.get_stripe_url, allow_other_host: true
=======
      checkout_service = StripeCheckoutService.new(payment_success_orders_url(order_id: @order.id), payment_failed_orders_url(order_id: @order.id), @order)
      if checkout_service.call
        redirect_to checkout_service.get_stripe_url, allow_other_host: true
      else
        flash.now[:alert] = 'error occured'
        render :new
      end
>>>>>>> order_process_jobs
    else
      render :new
    end
  end

  def placed
    transaction = @order.payment_transactions.find_by(status: :pending)
    if transaction&.update(status: :paid)
      flash[:notice] = "Order placed"
    else
      flash[:notice] = "payment failed"
    end 
    redirect_to orders_path
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
    redirect_to deals_path, alert: 'invalid order' if !@order
  end

end