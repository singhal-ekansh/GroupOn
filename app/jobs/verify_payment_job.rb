class VerifyPaymentJob < ApplicationJob
  def perform(order_id)
    order = Order.find_by(id: order_id)
    if order&.pending?
      order.deal.update_columns(qty_sold: order.deal.qty_sold - order.quantity)
      order.payment_transactions.where(status: :pending).update(status: :failed)
      order.update(status: :canceled)
    end
  end
end