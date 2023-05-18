class Location < ApplicationRecord
  validates :address, :state, :city, :pincode, presence: true
  

  has_and_belongs_to_many :deals
end