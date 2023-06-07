class Like < ActiveRecord::Base
  validates :liked, exclusion: [nil]
  validates :deal_id, uniqueness: { scope: :user_id }
  
  belongs_to :deal
  belongs_to :user

end