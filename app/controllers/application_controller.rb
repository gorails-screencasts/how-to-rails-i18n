class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :set_locale
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :masquerade_user!

  def set_locale
    if user_signed_in?
      I18n.locale = current_user.language
    else
      I18n.locale = params[:lang] || locale_from_header || I18n.default_locale
    end
  end

  def locale_from_header
    request.env.fetch('HTTP_ACCEPT_LANGUAGE', '').scan(/[a-z]{2}/).first
  end

  protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :language])
      devise_parameter_sanitizer.permit(:account_update, keys: [:name, :avatar, :language])
    end
end
