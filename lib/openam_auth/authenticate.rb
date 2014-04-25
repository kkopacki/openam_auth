module OpenamAuth
  module Authenticate
    extend ActiveSupport::Concern

    def authenticate_user!
      user ||= User.update_openam_user(token, user_hash) if openam.valid_token?(token)

      session[:user_id] = user.id if user

      !!session[:user_id] || redirect_to(openam.login_url)
    end

    private
    def openam
      OpenamAuth::Openam.new
    end

    def cookie_name
      openam.cookie_name
    end

    def token
      openam.token_cookie(request, cookie_name)
    end

    def user
      User.existing_user_by_token(token)
    end

    def current_user
      User.where(id: session[:user_id]).first
    end

    def user_hash
      openam.user_hash(openam_response.body)
    end

    def openam_response
      openam.openam_user(cookie_name, token)
    end

    def openam_logout(token)
      openam.new.logout(token)
    end
  end
end

