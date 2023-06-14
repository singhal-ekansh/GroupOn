class Order < ApplicationRecord
  validates :quantity, :amount, :status, presence: true
  validates :quantity, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validate :check_deal_availaible, if: [:quantity, :deal]
  validate :check_deal_published, if: :deal
  validate :check_deal_live, if: :deal
  validate :check_max_deal_per_user, if: [:quantity, :deal]

  belongs_to :user
  belongs_to :deal
  has_many :payment_transactions, class_name: 'Transaction'

  enum :status, [:pending, :paid, :processed, :canceled]

  before_validation :set_amount, if: :quantity_changed?
  
  def generate_stripe_session(success_url, cancel_url)
    Stripe::Checkout::Session.create(success_url: success_url, cancel_url: cancel_url,
      line_items: [{ price_data: { currency: 'inr', unit_amount: deal.price * 100, product_data: {name: deal.title} } ,
         quantity: quantity }], mode: 'payment', metadata: { order_id: id })
  end

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
    errors.add(:base, 'quantity exceed more than maximum allowed per user') if quantity_already_purchased + quantity > deal.max_per_user
  end

end