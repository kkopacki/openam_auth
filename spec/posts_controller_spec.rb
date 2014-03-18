require 'fixtures/application'
require 'fixtures/controllers'
require 'rspec/rails'
require 'spec_helper'

describe PostsController, type: :controller do

  let(:token) { '123456' }
  let!(:openam_url) { OpenamConfig.config do
                         openam_url 'http://server.openam.com'
                      end }
  let(:response) {  <<EOF
    userdetails.token.id=#{token}
    userdetails.attribute.name=mail
    userdetails.attribute.name=sunidentitymsisdnnumber
    userdetails.attribute.name=sn
    userdetails.attribute.value=amAdmin
EOF
}

  before { OpenamAuth::Openam.any_instance.stub(:token_cookie).and_return(token) }

  describe "#index, authenticate by the openam server" do

    before do
      stub_request(:post, "#{openam_url}/identity/getCookieNameForToken").
        to_return(:status => 200, :body => "string=iPlanetDirectoryPro\n", :headers => {})
    end

    subject { OpenamAuth::Openam.new }

    describe PostsController, "#when the token is valid"  do

      before do
        stub_request(:get, "#{openam_url}/identity/isTokenValid?tokenid=#{token}").
          to_return(:status => 200, :body => "boolean=true\n", :headers => {})
        stub_request(:post, "#{openam_url}/identity/attributes").
          with(:headers => {"Cookie"=>"iPlanetDirectoryPro=#{token}"}).
          to_return(:status => 200, :body => response, :headers => {})
      end

      it "should authenticate the request" do
        subject.cookie_name.should eq('iPlanetDirectoryPro')
        subject.token_cookie.should eq(token)
        User.existing_user_by_token(token).should be_nil
        subject.valid_token?(token).should be_true
        subject.openam_user('iPlanetDirectoryPro', token).to_s.should eq(response)
        subject.user_hash(subject.openam_user('iPlanetDirectoryPro', token)).should eq({ "sn" => ["amAdmin"] })

        get :index
        response.should be_true
      end

    end

    describe PostsController, "#when the token is invalid"  do

      before do
        stub_request(:get, "#{openam_url}/identity/isTokenValid?tokenid=#{token}").
        to_return(:status => 200, :body => "boolean=false\n", :headers => {})
      end

      it "should authenticate the request" do
        get :index
        response.should redirect_to "#{openam_url}/UI/Login?goto="
      end

    end

  end
end

