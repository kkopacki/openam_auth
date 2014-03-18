module OpenamAuth
  module Authenticate
    module ClassMethods ; end

    module InstanceMethods

      def authenticate_user!
        status = false
        openam = OpenamAuth::Openam.new
        cookie_name = openam.cookie_name
        token = openam.token_cookie(request, cookie_name)

        #The following class  method shold be implemented by the parent application
        user = User.existing_user_by_token(token)

        unless user
          if openam.valid_token?(token)
            response = openam.openam_user(cookie_name, token)
            user_hash = openam.user_hash(response.body)
            #following class method should be implemented by the parent application
            user = User.update_openam_user(token, user_hash)
          end
        end
        if user
          session[:user_id] = user.id
          status = true
        end
        status ? true : (redirect_to openam.login_url)
      end
    end

    def openam_logout(token)
      OpenamAuth::Openam.new.logout(token)
    end

    def current_user
      User.where(id: session[:user_id]).first
    end

    def self.included(receiver)
      receiver.extend         ClassMethods
      receiver.send :include, InstanceMethods
    end
  end
end

