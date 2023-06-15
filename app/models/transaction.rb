class Transaction < ApplicationRecord

  validates :stripe_id, presence: true

  belongs_to :order

  enum :status, [:pending, :paid, :failed, :refunded]
end