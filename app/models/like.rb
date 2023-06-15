class Like < ActiveRecord::Base
  validates :is_liked, inclusion: [true, false]
  validates :user_id, uniqueness: { scope: [:likable_type, :likable_id] }
  
  belongs_to :likable, polymorphic: true
  belongs_to :user

end