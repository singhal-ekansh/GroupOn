class OrdersController < ApplicationController
  before_action :authenticate

  def new
    @order = Order.new
    @deal = Deal.find_by(id: params[:deal_id])
  end

  def index
    @orders = Order.where(user: current_user).order(created_at: :desc).paginate(page: params[:page], per_page: ORDER_PER_PAGE)
  end

  def create
    @deal = Deal.find_by(id: params[:deal_id])
    @order = Order.new(deal_id: params[:deal_id], user_id:  current_user.id, quantity: params[:order][:quantity],amount: params[:order][:quantity].to_i * @deal.price)

    if @order.save
      @deal.update_columns(qty_sold: @deal.qty_sold + @order.quantity)
      ActionCable.server.broadcast('deals_channel', {deal_id: @deal.id, qty: @deal.total_availaible - @deal.qty_sold })

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
    @checkout_session = Stripe::Checkout::Session.retrieve(session[:checkout_session])
    @order = Order.find_by(id: @checkout_session.metadata[:order_id])
    @order.payment_transactions.create( stripe_id: @checkout_session.payment_intent, order_id: @order.id, status: :paid )
    @order.update(status: :paid)
    redirect_to orders_path, notice: "Order placed"
  end

  def failed
    @checkout_session = Stripe::Checkout::Session.retrieve(session[:checkout_session])
    @order = Order.find_by(id: @checkout_session.metadata[:order_id])
    @deal = @order.deal
    @deal.update_columns(qty_sold: @deal.qty_sold - @order.quantity)
    ActionCable.server.broadcast('deals_channel', {deal_id: @deal.id, qty: @deal.total_availaible - @deal.qty_sold })
    @order.payment_transactions.create( stripe_id: @checkout_session.id, order_id: @order.id, status: :failed )
    @order.update(status: :canceled)
    redirect_to deals_path, alert: "payment failed"
  end

end