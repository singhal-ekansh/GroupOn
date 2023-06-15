class Transaction < ApplicationRecord

  validates :stripe_id, presence: true

  belongs_to :order

  before_update :change_order_status
  before_update :change_deal_quantity_sold

  enum :status, [:pending, :paid, :failed, :refunded]

  def change_order_status
    if paid? && status_was == 'pending'
      order.paid!
    elsif failed? && status_was == 'pending'
      order.canceled!
    end
  end

  def change_deal_quantity_sold
    if failed? && status_was == 'pending'
      order.deal.update_columns(qty_sold: order.deal.qty_sold - order.quantity)
    end
  end
end