class Customer < ApplicationRecord
  include Filterable

  belongs_to :recruitment_center
  belongs_to :country
  belongs_to :region

  has_many :requests, inverse_of: :customer, dependent: :destroy

  accepts_nested_attributes_for :requests

  validates_presence_of :name, :surname, :address, :recruitment_center_id, :country_id, :region_id

  def offers
    self.requests.map { |request| request.offer }
  end

  def self.filter_by_has_unresolved_request(scope, value)
    if Utility.yes? value
      scope.left_joins(requests: :offer).where.not(requests: {id: Offer.select(:request_id).distinct}).distinct
    else
      scope.left_joins(requests: :offer).where(requests: {id: Offer.select(:request_id).distinct}).distinct
    end
  end
end
