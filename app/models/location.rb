class Location < ApplicationRecord
  validates :address, :state, :city, :pincode, presence: true
  
  belongs_to :deal
end