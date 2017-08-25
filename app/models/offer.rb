class Offer < ApplicationRecord
  belongs_to :request

  has_many :offer_files, inverse_of: :offer, dependent: :destroy

  accepts_nested_attributes_for :offer_files

  delegate :customer, to: :request

  validates_presence_of :request_id
end
