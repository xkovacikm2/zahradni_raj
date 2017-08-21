class Request < ApplicationRecord
  belongs_to :customer, inverse_of: :requests

  has_one :offer, dependent: :destroy

  before_save :sanitize_categories

  def categories
    RequestCategory.where('request_categories.id IN ?', self.request_categories)
  end

  private

  def sanitize_categories
    self.request_categories.reject! { |e| e.blank? } if self.request_categories.respond_to? :reject!
  end
end
