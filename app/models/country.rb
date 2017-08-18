class Country < ApplicationRecord
  has_many :customers, dependent: :nullify
  has_many :regions, dependent: :destroy
end
