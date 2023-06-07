class Order < ApplicationRecord
  validates :quantity, :amount, :status, presence: true
  validate :deal_validations

  belongs_to :user
  belongs_to :deal
  has_many :payment_transactions, class_name: 'Transaction'
  has_many :coupons

  enum :status, [:pending, :paid, :processed, :canceled]

  def deal_validations
    errors.add(:quantity, 'exceed more than availaible deals') if quantity > (deal.total_availaible - deal.qty_sold)
    errors.add(:base, 'order can be placed only for published deals') unless deal.published
    errors.add(:base, 'order can be placed only for live deals') unless Date.today.between?(deal.start_at, deal.expire_at)
    quantity_already_purchased = deal.orders.where(user_id: user_id).where(status: :paid).sum(:quantity)
    errors.add(:base, 'quantity exceed more than maximum allowed per user') if quantity_already_purchased + quantity > deal.max_per_user
  end

  def generate_coupons
    quantity.times do 
      self.coupons.create
    end
  end
end