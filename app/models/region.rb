class Region < ApplicationRecord
  include Filterable

  belongs_to :country
end
