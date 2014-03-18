require 'httparty'

module OpenamAuth
  class Openam
    include HTTParty

    COOKIE_NAME_FOR_TOKEN = "/identity/getCookieNameForToken"
    IS_TOKEN_VALID = "/identity/isTokenValid"

    def initialize(base_url)
      @base_url = base_url
    end

    def cookie_name
      response = self.class.post("#{@base_url}#{COOKIE_NAME_FOR_TOKEN}", {})
      response.body.split('=').last.strip
    end

    def token_cookie(request, cookie_name)
      token_cookie = CGI.unescape(request.cookies.fetch(token_cookie_name, nil).to_s.gsub('+', '%2B'))
      token_cookie != '' ? token_cookie : nil
    end

    def valid_token?(token)
      response = self.class.get("#{@base_url}#{IS_TOKEN_VALID}?tokenid=#{token}", {})
      response.body.split('=').last.strip == 'true'
    end

    def openam_user(token_cookie_name, token)

    end


  end
end

