class Coupon < ApplicationRecord
  
  before_create :generate_code

  belongs_to :order

  def generate_code
    self.code = Time.now.to_i.to_s.split('').shuffle.map{ |s| (s.to_i.odd?) ? (s.to_i + 65).chr : s }.join
  end

end