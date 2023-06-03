class Order < ApplicationRecord
  validates :quantity, :amount, :status, presence: true

  belongs_to :user
  belongs_to :deal
  has_many :payment_transactions, class_name: 'Transaction'

  enum :status, [:pending, :paid, :processed, :canceled]
end