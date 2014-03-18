require 'openam_auth'

class User

  attr_accessor :id, :name

  def self.existing_user_by_token(token)
    nil
  end

  def self.update_openam_user(token, user_hash)
    User.new
  end

end

class ApplicationController < ActionController::Base
  include Rails.application.routes.url_helpers

  def render(*attributes); end
end

class PostsController < ApplicationController
  include OpenamAuth::Authenticate

  before_filter :authenticate_user!

  def index; end
end
