class User < ApplicationRecord
  include Filterable

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable

  validates :email, format: Devise.email_regexp, presence: true, uniqueness: true

  default_scope -> () { order id: :asc }
end
