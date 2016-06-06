module OpenamAuth
  module Authenticate
    attr_accessor :openam_instance
    extend ActiveSupport::Concern

    def authenticate_user!
      clear_sesion_and_redirect and return unless openam.uid(request)
      set_session_user_id if openam_user
    end

    def openam_logout!
      openam.logout(request)
    end

    private

    def openam
      @openam_instance ||= OpenamAuth::Openam.new
    end

    def set_session_user_id
      session[:user_id] = openam_user.id
      self.current_user ||= openam_user
    end

    def openam_user
      @openam_user ||= openam.find_or_update_user(request)
    end

    def clear_sesion_and_redirect
      session[:user_id] = nil
      redirect_to openam.login_url(request)
    end
  end
end
