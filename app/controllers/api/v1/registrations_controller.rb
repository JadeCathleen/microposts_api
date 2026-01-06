class Api::V1::RegistrationsController < Devise::RegistrationsController
  include ActionController::Flash
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    render json: {
      user: {
        id: resource.id,
        username: resource.username,
        email: resource.email
      },
      message: "Signed up successfully"
    }, status: :ok
  end
end
