# frozen_string_literal: true

class ProcessDealOrdersJob < ApplicationJob
  queue_as :default

  def perform(*args)
    deals_expired_yesterday = Deal.includes(:orders).where(expire_at: Date.yesterday).where(orders: { status: :paid })
    deals_expired_yesterday.each do |deal|
      (deal.qty_sold >= deal.threshold_value) ? order_success(deal) : order_failed(deal)
    end
  end

  private def order_success(deal)
    orders = deal.orders
    orders.each do |order|
      order.update(status: :processed, processed_at: Time.now)
    end
  end

  private def order_failed(deal)
    orders = deal.orders
    orders.each do |order|
      order.update(status: :canceled, processed_at: Time.now)
    end
  end

end
