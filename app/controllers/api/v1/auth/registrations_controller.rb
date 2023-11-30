class Api::V1::Auth::RegistrationsController < DeviseTokenAuth::RegistrationsController
  private

    def sign_up_params
      p '@@@@@@@@@@@@@@@@@@@@@@@@@'
      p '@@@@@@@@@@@@@@@@@@@@@@@@@'
      p '@@@@@@@@@@@@@@@@@@@@@@@@@'
      p '@@@@@@@@@@@@@@@@@@@@@@@@@'
      p '@@@@@@@@@@@@@@@@@@@@@@@@@'
      p '@@@@@@@@@@@@@@@@@@@@@@@@@'
      params.permit(:email, :password, :password_confirmation, :name)
    end
end
