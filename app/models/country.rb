class Country < ApplicationRecord
  include Filterable

  has_many :customers, dependent: :nullify
  has_many :regions, dependent: :destroy
end
