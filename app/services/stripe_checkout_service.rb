class StripeCheckoutService

  def initialize(success_url = nil, cancel_url = nil, order)
    @success_url = success_url
    @cancel_url = cancel_url
    @order = order
  end
  
  def call
    retreive_customer
    generate_stripe_session
    generate_transaction
  end

  def get_stripe_url
    @stripe_session.url
  end

  def generate_refund
    retreive_checkout_session
    refund_object = Stripe::Refund.create( payment_intent: @stripe_session.payment_intent)
    @order.payment_transactions.create(stripe_id: refund_object.id, status: :refunded)
  end

  private def generate_stripe_session
    @stripe_session = Stripe::Checkout::Session.create(success_url: @success_url, cancel_url: @cancel_url,
      line_items: [{ price_data: { currency: 'inr', unit_amount: @order.deal.price * 100, product_data: {name: @order.deal.title} } ,
         quantity: @order.quantity }], mode: 'payment', customer: @customer.id, metadata: { order_id: @order.id })
  end

  private def retreive_customer
    if @order.user.stripe_customer_id
      @customer = Stripe::Customer.retrieve(@order.user.stripe_customer_id)
    else
      create_customer
    end
  end

  private def create_customer
    @customer = Stripe::Customer.create(
      name: "#{@order.user.first_name} #{@order.user.last_name}",
      email: @order.user.email
    )
    @order.user.update(stripe_customer_id: @customer.id)
  end

  private def generate_transaction
    transaction = @order.payment_transactions.build(stripe_id: @stripe_session.id, status: :pending)
    transaction.save
  end

  private def retreive_checkout_session
    checkout_id = @order.payment_transactions.find_by(status: :paid).stripe_id
    @stripe_session = Stripe::Checkout::Session.retrieve(checkout_id)
  end
end