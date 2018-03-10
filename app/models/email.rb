class Email < ApplicationRecord
  default_scope ->(){ order created_at: :desc }

  validates_presence_of :subject, :body
end
