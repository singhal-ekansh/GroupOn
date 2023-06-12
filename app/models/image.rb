class Image < ApplicationRecord

  has_one_attached :file, dependent: :destroy
  validate :file_presence
  validate :file_type
  validate :file_size

  private def file_presence
    errors.add(:image, 'file must be selected') if !file.attached?
  end

  private def file_type
    errors.add(:image, 'must be png or jpg') if file.attached? && !file.blob.content_type.in?(ALLOWED_IMAGE_TYPES)
  end

  private def file_size
    errors.add(:image, 'size too big') if file.attached? && file.blob.byte_size > ALLOWED_IMAGE_SIZE
  end

end