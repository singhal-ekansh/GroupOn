class Order < ApplicationRecord
  validates :quantity, :amount, :status, presence: true

  belongs_to :user
  belongs_to :deal

  enum :status, [:pending, :delivered, :canceled]
end