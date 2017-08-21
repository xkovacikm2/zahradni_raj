class OfferFile < ApplicationRecord
  mount_uploader :stored_filename, ::FileUploader

  belongs_to :offer

  def public_name
    self.original_filename + self.extension
  end
end
