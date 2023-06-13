class OrdersController < ApplicationController
  before_action :authenticate
  before_action :set_deal, only: [:new, :create]
  before_action :retrieve_checkout_session, only: [:placed, :failed]

  def new
    @order = Order.new
  end

  def index
    @orders = Order.where(user: current_user).order(created_at: :desc)
  end

  def create
    @order = Order.new(deal_id: params[:deal_id], user_id:  current_user.id, quantity: params[:order][:quantity],amount: params[:order][:quantity].to_i * @deal.price)

    if @order.save
      @deal.update_columns(qty_sold: @deal.qty_sold + @order.quantity)

      @checkout_session = Stripe::Checkout::Session.create(success_url: order_success_url, cancel_url: order_failed_url,
        line_items: [{ price_data: { currency: 'inr', unit_amount: @deal.price * 100, product_data: {name: @deal.title} } ,
           quantity: @order.quantity }], mode: 'payment', metadata: { order_id: @order.id })
       
      session[:checkout_session] = @checkout_session.id  
      VerifyPaymentJob.set(wait: 2.minutes).perform_later(@checkout_session.id)

      redirect_to @checkout_session.url, allow_other_host: true
    else
      render :new
    end
  end

  def placed
    @order = Order.find_by(id: @checkout_session.metadata[:order_id])
    @order.payment_transactions.create( stripe_id: @checkout_session.payment_intent, status: :paid )
    @order.update(status: :paid)
    redirect_to orders_path, notice: "Order placed"
  end

  def failed
    @order = Order.find_by(id: @checkout_session.metadata[:order_id])
    @order.deal.update_columns(qty_sold: @order.deal.qty_sold - @order.quantity)
    @order.payment_transactions.create( stripe_id: @checkout_session.id, status: :failed )
    @order.update(status: :canceled)
    redirect_to deals_path, alert: "payment failed"
  end

  private def set_deal
    @deal = Deal.find_by(id: params[:deal_id])
    redirect_to deals_path, alert: 'invalid deal' if !@deal
  end

  private def retrieve_checkout_session
    @checkout_session = Stripe::Checkout::Session.retrieve(session[:checkout_session]) if session[:checkout_session]
    if !@checkout_session || !@checkout_session.status.eql?('open')
      redirect_to deals_path, alert: 'session expired'
    end
    session[:checkout_session] = nil
  end
end