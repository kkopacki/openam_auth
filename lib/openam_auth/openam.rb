require 'httparty'

module OpenamAuth
  class Openam

    include HTTParty

    format :json

    URIS = {
      'login' => '/UI/Login?goto=',
      'server_info' => '/json/serverinfo/*',
      'sessions' => '/json/sessions/',
      'users' => '/json/users/'
    }.freeze

    def initialize
      @return_url = OpenamAuth::Config.return_url
      @openam_url = OpenamAuth::Config.openam_url
    end

    def uid(request)
      return nil unless token(request)
      response = self.class.post(
        "#{url('sessions')}#{token(request)}",
        {
          query: { '_action' => 'validate' },
          headers: {'Content-Type' => 'application/json'}
        }
      )
      response&.fetch('valid', nil) && response&.fetch('uid', nil)
    end

    def login_url(request)
      [url('login'), return_url(request)].compact.join
    end

    def find_or_update_user(request)
      return nil unless token(request)
      User.existing_user_by_token(token(request)) || User.update_openam_user(token(request), user_hash(request))
    end

    def logout(request)
      return true unless token(request)
      response = self.class.post(
        url('sessions'),
        {
          headers: { cookie_name => token(request), 'Content-Type' => 'application/json' },
          query: { '_action' => 'logout' }
        }
      )
      !!response&.fetch('result', nil)
    end

    private

    def token(request)
      session_token = request.cookies.fetch(cookie_name, nil)
      @token ||= session_token ? CGI.unescape(session_token.to_s) : nil
    end

    def server_info
      @server_info ||= self.class.get(url('server_info'), { headers: { 'Content-Type' => 'application/json' } })
    end

    def cookie_name
      @cookie_name ||= server_info['cookieName']
    end

    def url(t)
      [@openam_url, URIS[t]].join
    end

    def return_url(request)
      return request.host_with_port unless @return_url
      if @return_url.respond_to?(:call)
        @return_url.call(request)
      else
        @return_url
      end
    end

    def user_hash(request)
      self.class.get("#{url('users')}#{uid(request)}", { headers: { cookie_name => token(request) }, query: {} })
    end
  end
end

