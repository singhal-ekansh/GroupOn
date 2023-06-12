class Image < ApplicationRecord

  has_one_attached :file, dependent: :destroy
  validate :file_validations

  def file_validations
    errors.add(:image, 'file must be selected') unless file.attached?
    errors.add(:image, 'must be png or jpg') if file.attached? && !file.blob.content_type.in?(ALLOWED_IMAGE_TYPES)
    errors.add(:image, 'size too big') if file.attached? && file.blob.byte_size > ALLOWED_IMAGE_SIZE
  end
end