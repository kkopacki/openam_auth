require 'spec_helper'
require 'openam_auth'

describe OpenamAuth do

  let(:token) { '121212121' }
  let!(:openam_url) { OpenamConfig.config do
                        openam_url 'http://server.openam.com'
                      end }

  describe OpenamAuth, "#get cookie name"  do
    before do
      stub_request(:post, "#{openam_url}/identity/getCookieNameForToken").
        to_return(:status => 200, :body => "string=iPlanetDirectoryPro\n", :headers => {})
    end

    it "should return the correct cookie name" do
      OpenamAuth::Openam.new.cookie_name.should eq("iPlanetDirectoryPro")
    end
  end

  describe OpenamAuth, "#validating token" do

    before do
      stub_request(:get, "#{openam_url}/identity/isTokenValid?tokenid=#{token}").
        to_return(:status => 200, :body => "boolean=true\n", :headers => {})
    end

    it "should be a valid token" do
      OpenamAuth::Openam.new.valid_token?(token).should be_true
    end
  end

  describe OpenamAuth, "#openam user" do
    let(:response) {  <<EOF
    userdetails.token.id=#{token}
    userdetails.attribute.name=mail
    userdetails.attribute.name=sunidentitymsisdnnumber
    userdetails.attribute.name=sn
    userdetails.attribute.value=amAdmin
EOF
    }

    before do
      stub_request(:post, "#{openam_url}/identity/attributes").
        with(:headers => {"Cookie"=>"iPlanetDirectoryPro=#{token}"}).
        to_return(:status => 200, :body => response, :headers => {})
    end

    it "should return openam user string" do
      OpenamAuth::Openam.new.openam_user('iPlanetDirectoryPro',token).to_s.should eq(response)
    end

    it "should parse response" do
      OpenamAuth::Openam.new.user_hash(response).should eq({"sn" => ["amAdmin"] })
    end

  end

end
