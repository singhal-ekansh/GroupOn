class Transaction < ApplicationRecord

  validates :stripe_id, presence: true

  belongs_to :order

  before_update :change_order_status

  enum :status, [:pending, :paid, :failed, :refunded]

  def change_order_status
    if paid? && status_was == 'pending'
      order.paid!
    elsif failed? && status_was == 'pending'
      order.canceled!
    end
  end
end