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

  def unresolved_requests?
    @unresolved = self.requests.any? { |request| request.offer.nil? } if @unresolved.nil?
    @unresolved
  end

  def self.filter_by_has_unresolved_request(scope, value)
    if Utility.yes? value
      scope.left_joins(requests: :offer).group('customers.id').having('COUNT(requests.*) > COUNT(offers.*)')
    else
      scope.left_joins(requests: :offer).group('customers.id').having('COUNT(requests.*) = COUNT(offers.*)')
    end
  end

  def self.filter_by_request_date_from(scope, value)
    scope.left_joins(:requests).where('requests.date >= ?', Date.parse(value)).distinct
  end

  def self.filter_by_request_date_to(scope, value)
    scope.left_joins(:requests).where('requests.date <= ?', Date.parse(value)).distinct
  end

  def self.filter_by_offer_date_from(scope, value)
    scope.left_joins(requests: :offer).where('offers.date >= ?', Date.parse(value)).distinct
  end

  def self.filter_by_offer_date_to(scope, value)
    scope.left_joins(requests: :offer).where('offers.date <= ?', Date.parse(value)).distinct
  end
end
