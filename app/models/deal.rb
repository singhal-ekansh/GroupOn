class Deal < ApplicationRecord
  validates :title, :description, :price, :start_at, :expire_at, :threshold_value, :total_availaible, presence: true
  validates :expire_at, comparison: { greater_than: :start_at }, allow_blank: true
  validates :price, :threshold_value, :total_availaible, :max_per_user, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_blank: true
  validates :threshold_value, comparison: { less_than_or_equal_to: :total_availaible }, allow_blank: true
  validate :verify_publisher_admin_only

  belongs_to :user
  belongs_to :category
  has_many_attached :images
  has_many :locations
  accepts_nested_attributes_for :locations, allow_destroy: true
  accepts_nested_attributes_for :images_attachments, allow_destroy: true

  before_create :set_count_left

  private def set_count_left
    self.count_left = total_availaible
  end

  private def verify_publisher_admin_only
    unless User.find_by(id: user_id)&.is_admin
      errors.add(:base, 'only admin can add deals')
    end
  end
end
