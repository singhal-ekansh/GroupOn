class Coupon < ApplicationRecord
  validates :code, presence: true, uniqueness: true
  before_validation :generate_code

  belongs_to :order

  def generate_code
    self.code = SecureRandom.hex(5) if !code
  end

end