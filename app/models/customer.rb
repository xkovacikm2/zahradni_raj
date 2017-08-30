class Customer < ApplicationRecord
  include Filterable

  belongs_to :recruitment_center, optional: true
  belongs_to :country, optional: true
  belongs_to :region, optional: true
  belongs_to :customer_status, optional: true

  has_many :requests, inverse_of: :customer, dependent: :destroy

  accepts_nested_attributes_for :requests

  validates_format_of :email, :with => Devise::email_regexp
  validates_presence_of :email
  validates_uniqueness_of :email

  def offers
    self.requests.map { |request| request.offer }
  end

  def contact_date
    self.offers.compact.select{ |offer| offer.contact_date >= Date.current }.sort_by(&:contact_date).first&.contact_date
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

  def self.filter_by_contact_date_from(scope, value)
    scope.left_joins(requests: :offer).where('offer.contact_date >= ?', Date.parse(value)).distinct
  end

  def self.filter_by_contact_date_to(scope, value)
    scope.left_joins(requests: :offer).where('requests.contact_date <= ?', Date.parse(value)).distinct
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
