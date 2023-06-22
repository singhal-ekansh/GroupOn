# frozen_string_literal: true

class ProcessDealOrdersJob < ApplicationJob
  queue_as :default

  def perform(*args)
    @orders = Order.joins(:deal).where(deal: { expire_at: Date.yesterday }).where(status: :paid)
    set_orders_success 
    set_orders_failed
  end

  private def set_orders_success
    @orders.where('deal.qty_sold >= deal.threshold_value').update(status: :processed)
  end

  private def set_orders_failed
    @orders.where('deal.qty_sold < deal.threshold_value').update(status: :canceled)
  end

end
