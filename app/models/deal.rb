class Deal < ApplicationRecord
  validates :title, presence: true
  validate :ensure_published_by_admin

  with_options if: -> { published } do |deal|
    deal.validates :description, :price, :start_at, :expire_at, :threshold_value, :total_availaible, presence: true
    deal.validates :start_at, comparison: { greater_than: Date.today, message: "has to be a future date" }, allow_blank: true
    deal.validates :expire_at, comparison: { greater_than_or_equal_to: :start_at, message: "must be greater or equal to start date" }, allow_blank: true, if: -> { start_at }
    deal.validates :price, :threshold_value, :total_availaible, :max_per_user, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_blank: true
    deal.validates :threshold_value, comparison: { less_than_or_equal_to: :total_availaible }, allow_blank: true, if: -> { total_availaible }
    deal.validates :deal_images, :length => { :minimum => 1, message: 'must include a image' }
    deal.validates :locations, :length => { :minimum => 1, message: 'must include a location' }
  end

  belongs_to :user
  belongs_to :category
  has_many :deal_images, dependent: :destroy
  has_many :locations, dependent: :destroy
  accepts_nested_attributes_for :locations, allow_destroy: true, reject_if: lambda { |attr| attr.any? { |k,v| k!=false && v.blank? } }
  accepts_nested_attributes_for :deal_images, allow_destroy: true, reject_if: lambda { |attr| !attr.key?('file') }
  has_many :likes, dependent: :destroy
  has_many :orders
  has_many :coupons, through: :orders
  
  before_validation :ensure_live_expired_deals_updation, on: :update

  scope :published, -> { where(published: true) }

  private def ensure_live_expired_deals_updation
    if start_at_was <= Date.today
      errors.add(:base, 'Live and expired deals can not be updated')
    end
  end

  private def ensure_published_by_admin
    unless User.verified.find_by(id: user_id)&.is_admin
      errors.add(:base, 'only admin can add deals')
    end
  end

end
