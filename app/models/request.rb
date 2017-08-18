class Request < ApplicationRecord
  belongs_to :customer

  has_one :offer, dependent: :destroy

  def categories
    RequestCategory.where('request_categories.id IN ?', self.request_categories)
  end
end
