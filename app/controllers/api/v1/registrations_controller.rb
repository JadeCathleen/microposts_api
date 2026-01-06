class Api::V1::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  def create
    build_resource(sign_up_params)

    if resource.save
      render json: {
        user: {
          id: resource.id,
          username: resource.username,
          email: resource.email
        },
        message: "Signed up successfully"
      }, status: :created
    else
      clean_up_passwords resource
      set_minimum_password_length

      render json: {
        errors: resource.errors.full_messages
      }, status: :unprocessable_entity
    end
  end
end
