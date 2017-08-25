class OfferFile < ApplicationRecord
  mount_uploader :stored_filename, ::FileUploader

  belongs_to :offer, inverse_of: :offer_files

  delegate :customer, to: :offer

  def public_name
    self.original_filename + self.extension
  end
end
