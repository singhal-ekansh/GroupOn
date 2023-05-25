class Image < ApplicationRecord

  has_one_attached :file, dependent: :destroy
  validate :file_validations


  def file_validations
    errors.add(:base, "image must be present") unless file.attached?
  end
end