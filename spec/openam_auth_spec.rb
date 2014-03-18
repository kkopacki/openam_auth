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
      OpenamAuth::Openam.new(openam_url).cookie_name.should eq("iPlanetDirectoryPro")
    end
  end

  describe OpenamAuth, "#validating token" do

    before do
      stub_request(:get, "#{openam_url}/identity/isTokenValid?tokenid=#{token}").
        to_return(:status => 200, :body => "boolean=true\n", :headers => {})
    end

    it "should be a valid token" do
      OpenamAuth::Openam.new(openam_url).valid_token?(token).should be_true
    end
  end

  describe OpenamAuth, "#openam user" do
    let(:response) {  <<EOF
    userdetails.token.id=#{token}\nuserdetails.attribute.name=mail\nuserdetails.attribute.name=sunidentitymsisdnnumber\nuserdetails.attribute.name=sn\nuserdetails.attribute.value=amAdmin\nuserdetails.attribute.name=employeenumber\nuserdetails.attribute.name=postaladdress\nuserdetails.attribute.name=cn\nuserdetails.attribute.value=amAdmin\nuserdetails.attribute.name=iplanet-am-user-success-url\nuserdetails.attribute.name=roles\nuserdetails.attribute.name=iplanet-am-user-failure-url\nuserdetails.attribute.name=givenname\nuserdetails.attribute.value=amAdmin\nuserdetails.attribute.name=inetuserstatus\nuserdetails.attribute.value=Active\nuserdetails.attribute.name=dn\nuserdetails.attribute.value=uid=amAdmin,ou=people,dc=openam,dc=forgerock,dc=org\nuserdetails.attribute.name=telephonenumber\nuserdetails.attribute.name=iplanet-am-user-alias-list\n
EOF
    }

    it "should return the openam user string" do

    end


  end

end
