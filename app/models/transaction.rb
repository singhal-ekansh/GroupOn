class Transaction < ApplicationRecord

  validates :stripe_id, presence: true

  belongs_to :order

  enum :status, [:paid, :failed, :refunded]
end