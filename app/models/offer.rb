class Offer < ApplicationRecord
  belongs_to :request

  has_many :offer_files, dependent: :destroy

  validates_presence_of :request_id

  def customer
    self.request.customer
  end
end
