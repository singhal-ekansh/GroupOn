class OrdersController < ApplicationController
  before_action :authenticate
  before_action :set_deal, only: [:new, :create]
  before_action :retrieve_checkout_session, only: [:placed, :failed]
  before_action :set_order, only: [:placed, :failed]

  def new
    @order = Order.new
  end

  def index
    @orders = Order.where(user: current_user).order(created_at: :desc)
  end

  def create
    @order = Order.new(deal_id: params[:deal_id], user_id:  current_user.id, quantity: params[:order][:quantity])

    if @order.save
      @deal.update_columns(qty_sold: @deal.qty_sold + @order.quantity)
      @checkout_session = @order.generate_stripe_session( order_success_url, order_failed_url )
      session[:checkout_session] = @checkout_session.id  
      redirect_to @checkout_session.url, allow_other_host: true
    else
      render :new
    end
  end

  def placed
    @order.payment_transactions.create( stripe_id: @checkout_session.payment_intent, status: :paid )
    @order.update_columns(status: :paid)
    redirect_to orders_path, notice: "Order placed"
  end

  def failed
    @order.deal.update_columns(qty_sold: @order.deal.qty_sold - @order.quantity)
    @order.payment_transactions.create( stripe_id: @checkout_session.id, status: :failed )
    @order.update_columns(status: :canceled)
    redirect_to orders_path, alert: "payment failed"
  end

  private def set_deal
    @deal = Deal.find_by(id: params[:deal_id])
    redirect_to deals_path, alert: 'invalid deal' if !@deal
  end

  private def set_order
    @order = Order.find_by(id: @checkout_session.metadata[:order_id])
  end

  private def retrieve_checkout_session
    @checkout_session = Stripe::Checkout::Session.retrieve(session[:checkout_session]) if session[:checkout_session]
    if !@checkout_session || !@checkout_session.status.eql?('complete')
      redirect_to root_path, alert: 'session expired'
    end
    session[:checkout_session] = nil
  end
end