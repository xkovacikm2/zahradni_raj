class CustomerStatus < ApplicationRecord
  include Filterable

  has_many :customers, dependent: :nullify
end
