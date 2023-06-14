class Deal < ApplicationRecord
  validates :title, presence: true
  validate :ensure_published_by_admin

  with_options if: -> { published } do |deal|
    deal.validates :description, :price, :start_at, :expire_at, :threshold_value, :total_availaible, presence: true
    deal.validates :start_at, comparison: { greater_than_or_equal_to: Date.today, message: "can not be a past date" }, allow_blank: true
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

  before_validation :check_if_deal_can_be_updated?, on: :update, if: -> { published_was }
  before_destroy :check_if_deal_can_be_deleted?

  scope :published, -> { where(published: true) }
  scope :live, -> { where(start_at: (..Date.today), expire_at: (Date.today..)) }
  scope :expired, -> { where.not(expire_at: (Date.today..))}
  scope :search_by_city_and_title, ->(query) { where("title LIKE ? OR locations.city LIKE ?", query, query).references(:locations) }
  scope :filter_by_category, ->(category_id) { where( category_id: category_id) }

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
