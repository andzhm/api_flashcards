require 'rails-api'

module ApiFlashcards
  class ApiController < ActionController::API
    include ActionController::HttpAuthentication::Basic::ControllerMethods
    before_action :authenticate_basic

    resource_description do
      api_version '1'
    end

    protected

    def authenticate_basic
      authenticate_or_request_with_http_basic do |email, password|
        auth = User.where(email: email).first
        if auth
          @current_user = auth
        else
          render json: { message: 'Authentication failed'}, status: :unauthorized
        end
      end
    end

    def current_user
      @current_user
    end
  end
end