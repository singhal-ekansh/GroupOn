class StripeCheckoutService

  def initialize(current_user, success_url, cancel_url, order)
    @current_user = current_user
    @success_url = success_url
    @cancel_url = cancel_url
    @order = order
  end
  

  def generate_payment
    retreive_customer
    generate_stripe_session
    generate_transaction
  end

  def get_stripe_url
    @stripe_session.url
  end

  private def generate_stripe_session
    @stripe_session = Stripe::Checkout::Session.create(success_url: @success_url, cancel_url: @cancel_url,
      line_items: [{ price_data: { currency: 'inr', unit_amount: @order.deal.price * 100, product_data: {name: @order.deal.title} } ,
         quantity: @order.quantity }], mode: 'payment', customer: @customer.id, metadata: { order_id: @order.id })
  end

  private def retreive_customer
    begin
      @customer = Stripe::Customer.retrieve(@current_user.stripe_customer_id)
    rescue
      create_customer
    end
  end

  private def create_customer
    @customer = Stripe::Customer.create(
      name: "#{@current_user.first_name} #{@current_user.last_name}",
      email: @current_user.email
    )
    @current_user.update(stripe_customer_id: @customer.id)
  end

  private def generate_transaction
    @order.payment_transactions.create(stripe_id: @stripe_session.id, status: :pending)
  end

end