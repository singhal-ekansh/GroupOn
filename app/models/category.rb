class Category < ApplicationRecord

  validates :name, presence: true
  validates :name, uniqueness: { case_sensitive: false }

  has_many :deals, dependent: :destroy

  scope :popular, -> { joins(deals: :orders).group(:id).order("sum(quantity) desc") }
end