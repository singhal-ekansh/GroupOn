class Location < ApplicationRecord
  validates :address, :state, :city, :pincode, :country, presence: true
  
  belongs_to :deal
end