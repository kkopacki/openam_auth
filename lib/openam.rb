require 'httparty'

module OpenamAuth
  class Openam
    include HTTParty

    def initialize(base_url)
      @base_url = base_url
    end
  end
end

