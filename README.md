# OpenamAuth

ruby authentication client for forgerock OpenAM server (http://forgerock.com/products/open-identity-stack/openam/), this ruby client will work with OpenAM Policy Agent for Nginx https://bitbucket.org/hamano/nginx-mod-am

Read more about OpenAM REST api

https://wikis.forgerock.org/confluence/display/openam/Use+OpenAM+RESTful+Services


## Installation

Add this line to your application's Gemfile:

    gem 'openam_auth'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install openam_auth
    
## Running tests
  
    rspec

## Usage

### Using with Devise

1. install the gem (as described above)
2. create a file in `config/initializers`

```ruby
    #config/initializers/openam_config.rb
    OpenamConfig.config do
      openam_url <Path to your openam server>
    end
```
3. **openam_auth assumes** you have a `User` model in you project and it has the following two methods implemented


```ruby
   
   class User 
     
     # sends the token (from openam server) as a parameter
     def self.existing_user_by_token(token)
       # this method should return a user object, if matching record found
       # or nil if there are not matching record found
     end
     
     # authentication token from OpenAm server
     # user hash 
     # ex: { "sn" => ["admin"] }
     # NOTE: hash will have the key and value array
     def self.update_openam_user(token, hash)
       #this method should either update the existing user token, if user found
       #or create a new user and return that user
     end
     
   end

```

**Note**, you may want to add some more columns for the existing `users` table to accomodate the values passed by the hash. Read the section *3.5. Token Validation, Attribute Retrieval*  http://openam.forgerock.org/openam-documentation/openam-doc-source/doc/dev-guide/#rest-api-auth for more info.




4.  in your controller , `Ex: ApplicationController`, include the `OpenamAuth::Authenticate` module

```ruby
   class ApplicationController < ActionController::Base
      include OpenamAuth::Authenticate
   end
```

5 . Finally implement the before_filter for `authenticate_user!`

```ruby
   before_filter :authenticate_user!    
```
6 . For `logout` you could  use `openam_logout` with current user token from your controller

```ruby
  openam_logout(<current user token>)
```

### Special thanks :)   

https://github.com/tychobrailleur/openam-sample

http://speakmy.name/2011/05/29/simple-configuration-for-ruby-apps/

http://say26.com/rspec-testing-controllers-outside-of-a-rails-application


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
