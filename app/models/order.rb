class Order < ApplicationRecord
  validates :quantity, :amount, :status, presence: true
  validates :quantity, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  validates :amount, numericality: { greater_than_or_equal_to: 0.01 }
  validate :check_deal_availaible, if: [:quantity, :deal]
  validate :check_deal_valid, if: :deal
  validate :check_max_deal_per_user, if: [:quantity, :deal], on: :create

  belongs_to :user
  belongs_to :deal
  has_many :payment_transactions, class_name: 'Transaction'

  enum :status, [:pending, :paid, :processed, :canceled]

  before_validation :set_amount, if: :quantity_changed?
  after_create :update_deal_quantity

  private def set_amount
    self.amount = quantity * deal.price
  end

  private def check_deal_availaible
    if status.in?(['pending', 'paid'])
      errors.add(:quantity, 'exceed more than availaible deals') if quantity > (deal.total_availaible - deal.qty_sold + (quantity_was || 0))
    end
  end

  private def check_deal_valid
    errors.add(:base, 'order can be placed only for live and published deals') if !Date.today.between?(deal.start_at, deal.expire_at) || !deal.published
  end

  private def check_max_deal_per_user
    quantity_already_purchased = deal.orders.where(user_id: user_id).where(status: [:paid, :pending]).sum(:quantity)
    errors.add(:base, "you can buy only #{deal.max_per_user - quantity_already_purchased} more deal") if quantity_already_purchased + quantity > deal.max_per_user
  end

  private def update_deal_quantity
    deal.increase_qty_by(quantity)
  end
end