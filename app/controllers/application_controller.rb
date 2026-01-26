class ApplicationController < ActionController::API
  include ActionController::MimeResponds
  include Pagy::Method
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    # For sign up
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :username ])

    # For account updates
    # devise_parameter_sanitizer.permit(:account_update, keys: [ :username ])
  end
end
