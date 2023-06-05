# frozen_string_literal: true

class ProcessDealOrdersJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do something later
    deals_expired_yesterday = Deal.includes(:orders).where(expire_at: Date.yesterday).where(orders: { status: :paid })
    deals_expired_yesterday.each do |deal|
      (deal.qty_sold >= deal.threshold_value) ? order_success(deal) : order_failed(deal)
    end
  end

  private def order_success(deal)
    orders = deal.orders
    orders.each do |order|
      OrderMailer.completed(order).deliver_later
      order.update_column(:status, :processed)
    end
  end

  private def order_failed(deal)
    orders = deal.orders
    orders.each do |order|
      OrderMailer.cancelled(order).deliver_later
      order.update_column(:status, :canceled)
      generate_refund(order)
    end
  end

  private def generate_refund(order)
    debugger
    refund_object = Stripe::Refund.create( payment_intent: order.payment_transactions.find_by(status: :paid).stripe_id )
    t = order.payment_transactions.create(stripe_id: refund_object.id, status: :refunded)
    t.errors.to_a
  end
end
