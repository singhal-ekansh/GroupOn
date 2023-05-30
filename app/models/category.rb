class Category < ApplicationRecord

  validates :name, presence: true
  validates :name, uniqueness: { case_sensitive: false }

  has_many :deals, dependent: :destroy
end