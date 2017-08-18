class Offer < ApplicationRecord
  belongs_to :request

  has_many :offer_files, dependent: :destroy
end
