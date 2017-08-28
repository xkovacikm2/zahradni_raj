class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_default_locale

  def set_default_locale
    I18n.default_locale = :cs
  end
end
