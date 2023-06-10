class Image < ApplicationRecord

  has_one_attached :file, dependent: :destroy

  validates :file, attached: true, content_type: { in: ALLOWED_IMAGE_TYPES } , size: { less_than: 5.megabytes , message: 'is too large' }
end