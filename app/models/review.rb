class Review < ApplicationRecord

  validates :body, presence: true
  validates :user_id, uniqueness: { scope: [:reviewable_id, :reviewable_type] }

  belongs_to :user
  belongs_to :reviewable, polymorphic: true
end