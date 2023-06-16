class Deal < ApplicationRecord
  self.per_page = 2
  validates :title, presence: true
  validate :ensure_published_by_admin

  with_options if: -> { published } do |deal|
    deal.validates :description, :price, :start_at, :expire_at, :threshold_value, :total_availaible, presence: true
    deal.validates :expire_at, comparison: { greater_than_or_equal_to: :start_at, message: "must be greater or equal to start date" }, allow_blank: true, if: -> { start_at }
    deal.validates :price, :threshold_value, :total_availaible, :max_per_user, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_blank: true
    deal.validates :threshold_value, :max_per_user, comparison: { less_than_or_equal_to: :total_availaible }, allow_blank: true, if: -> { total_availaible }
    deal.validates :deal_images, :length => { :minimum => 1, message: 'must include a image' }
    deal.validates :locations, :length => { :minimum => 1, message: 'must include a location' }
  end

  belongs_to :user
  belongs_to :category
  has_many :deal_images, dependent: :destroy
  has_many :locations, dependent: :destroy
  accepts_nested_attributes_for :locations, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :deal_images, allow_destroy: true, reject_if: ->(attr) { !attr.key?('file') }
  has_many :likes, as: :likable, dependent: :destroy
  has_many :coupons, through: :orders
  has_many :orders, dependent: :restrict_with_error

  before_validation :check_if_deal_can_be_updated?, on: :update, if: -> { published_was && !qty_sold_changed?}
  before_destroy :check_if_deal_can_be_deleted?

  scope :published, -> { where(published: true) }
  scope :live, -> { where(start_at: (..Date.today), expire_at: (Date.today..)) }
  scope :expired, -> { where.not(expire_at: (Date.today..))}
  scope :search_by_city_and_title, ->(query) { where("title LIKE ? OR locations.city LIKE ?", query, query).references(:locations) }
  scope :filter_by_category, ->(category_id) { where( category_id: category_id) }
  scope :most_revenue, -> (start_date = Date.today, end_date = nil) { joins(:orders).where(orders: {status: :processed, created_at: (start_date..end_date)}).group(:id, :title).order("sum(orders.amount) desc").sum(:amount) }
  

  def increase_qty_by(quantity)
    update(qty_sold: qty_sold + quantity)
    ActionCable.server.broadcast('deals_channel', {deal_id: id, qty: total_availaible - qty_sold })
  end

  def decrease_qty_by(quantity)
    update(qty_sold: qty_sold - quantity)
    ActionCable.server.broadcast('deals_channel', {deal_id: id, qty: total_availaible - qty_sold })
  end

  private def check_if_deal_can_be_updated?
    if start_at_was <= Date.today
      errors.add(:base, 'Live and expired deals can not be updated')
    end
  end

  private def check_if_deal_can_be_deleted?
    if published
      throw :abort
    end
  end

  private def ensure_published_by_admin
    if !user.is_admin
      errors.add(:base, 'only admin can add deals')
    end
  end

end
