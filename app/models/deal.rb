class Deal < ApplicationRecord
  validates :title, :description, :price, :start_at, :expire_at, :threshold_value, :total_availaible, presence: true
  validates :expire_at, comparison: { greater_than: :start_at }
  validates :price, :threshold_value, :total_availaible, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :threshold_value, comparison: { less_than_or_equal_to: :total_availaible }


  belongs_to :user
end
