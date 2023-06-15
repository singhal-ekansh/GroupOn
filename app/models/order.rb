class Order < ApplicationRecord
  validates :quantity, :amount, :status, presence: true
  validates :quantity, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validate :check_deal_availaible, if: [:quantity, :deal], on: :create
  validate :check_deal_published, if: :deal, on: :create
  validate :check_deal_live, if: :deal, on: :create
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
    errors.add(:quantity, 'exceed more than availaible deals') if quantity > (deal.total_availaible - deal.qty_sold)
  end

  private def check_deal_published
    errors.add(:base, 'order can be placed only for published deals') if !deal.published
  end

  private def check_deal_live
    errors.add(:base, 'order can be placed only for live deals') if !Time.now.between?(deal.start_at, deal.expire_at)
  end

  private def check_max_deal_per_user
    quantity_already_purchased = deal.orders.where(user_id: user_id).where(status: [:paid, :pending]).sum(:quantity)
    errors.add(:base, "you can buy only #{deal.max_per_user - quantity_already_purchased} more deal") if quantity_already_purchased + quantity > deal.max_per_user
  end

  private def update_deal_quantity
    deal.update_columns(qty_sold: deal.qty_sold + quantity)
  end
end