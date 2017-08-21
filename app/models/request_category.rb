class RequestCategory < ApplicationRecord
  include Filterable

  def requests
    Request.where('? IN requests.request_categories', self.id)
  end
end
