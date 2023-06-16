class VerifyPaymentJob < ApplicationJob
  def perform(order_id)
    order = Order.find_by(id: order_id)
    return if order.nil?

    if order.pending?
      order.payment_transactions.find_by(status: :pending)&.update(status: :failed)
    end
  end
end