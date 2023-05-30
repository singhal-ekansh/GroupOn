class Deal < ApplicationRecord
  validates :title, presence: true

  with_options if: -> { published } do |deal|
    deal.validates :description, :price, :start_at, :expire_at, :threshold_value, :total_availaible, presence: true
    deal.validates :expire_at, comparison: { greater_than: :start_at }, allow_blank: true, if: -> { start_at }
    deal.validates :price, :threshold_value, :total_availaible, :max_per_user, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_blank: true
    deal.validates :threshold_value, comparison: { less_than_or_equal_to: :total_availaible }, allow_blank: true, if: -> { total_availaible }
  end
  
  validate :ensure_published_by_admin

  belongs_to :user
  belongs_to :category

  private def ensure_published_by_admin
    unless User.verified.find_by(id: user_id)&.is_admin
      errors.add(:base, 'only admin can add deals')
    end
  end

end
