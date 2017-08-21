class Customer < ApplicationRecord
  include Filterable

  belongs_to :recruitment_center
  belongs_to :country
  belongs_to :region

  has_many :requests, inverse_of: :customer

  accepts_nested_attributes_for :requests

  validates_presence_of :name, :surname, :address, :recruitment_center_id, :country_id, :region_id

  def offers
    self.requests.map { |request| request.offer }
  end
end
