class OfferFile < ApplicationRecord
  mount_uploader :stored_filename, ::FileUploader

  belongs_to :offer
end
