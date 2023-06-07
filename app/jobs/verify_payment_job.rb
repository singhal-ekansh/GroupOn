class VerifyPaymentJob < ApplicationJob
  def perform(checkout_id)
    checkout_session = Stripe::Checkout::Session.retrieve(checkout_id)
    order = Order.find_by(id: checkout_session.metadata[:order_id])
    if order&.pending?
      deal = order.deal
      deal.update_columns(qty_sold: deal.qty_sold - order.quantity)
      order.payment_transactions.create( stripe_id: checkout_session.id, order_id: order.id, status: :failed )
      order.update_columns(status: :canceled)
    end
  end
end