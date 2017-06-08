# JkoApi

This is an API versioning gem for rails. Yes, there are a lot of really good and easy ones out there, but the issue with all of them is that when you make a version change, you're copying an entire folder of controllers, specs, and a bunch of routes over just for a single API change.

This gem lets you make a single change and reversion an API without copying over a billion files and specs.

## Props

90% of the code was originally written by [Justin Ko](https://github.com/justinko). Since he's lazy and won't make a gem from it, I'm doing it for him :stuck_out_tongue: That's why the gem is named after him. I've since modified some of the stuff, and will continue to make it easier to use and more configurable.

## Requirements

Rails 5+ and Ruby 2.3

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'jko_api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install jko_api

## Usage

In your `config/initializers/jko_api.rb` add

```ruby
JkoApi.configure do |c|
  # This is the default. You can override this if you need a different controller
  # c.base_controller = ApiApplicationController

  # This is the folder name where all the api controllers would go
  # c.api_namespace = 'api'

  # If you want to use your own authentication stuff, leave this as default
  # c.use_authentication = false

  # The built in authentication is Warden::OAuth2 with a Bearer strategy. Currently no other option exists
  # c.strategy = :bearer

  # If you use the authentication, then you will need to make some model, and set this value. More notes below.
  # c.token_model = SomeModelYouCreated
end
```

In your `config/routes.rb`

```ruby
JkoApi.routes self do
  version 1 do
    # put base routes and routes for version 1 here
    resources :foos
    resources :bars
  end
  version 2 # no route changes, maybe just a controller change
  version 3 do
    resources :bars, only: [:index] # only changes :bars in version 3
  end
end  
```

Place your version 1 controller code in `app/controllers/api/v1`. Controllers should all inherit from `ApiApplicationController`, or something that inherits from that.

```ruby
class Api::V1::BarsController < ApiApplicationController
  def index
    # do stuff
  end
  def show
    # show stuff
  end
end
```

Any controllers that you need to alter will go into a new folder in `app/controllers/api/v2`. Notice in this one we inherit from the last version controller.

```ruby
class Api::V2::BarsController < Api::V1::BarsController
  def index
    # do different stuff
  end
  # no need to redefine show action because it didn't change
end
```

We can still do this though

```ruby
class Api::V3::BarsController < ApiApplicationController
  def index
    # do different stuff
  end
end
```

You can test this all by booting up a simple rails app, then do `curl -H "Accept: application/vnd.api.v1+json" http://localhost:3000/bars`

The `Accept` header is required to make the calls.

## Authentication
If your API calls need to be authenticated by some API key, then you will need to configure a few more things.

```ruby
JkoApi.configure do |c|
  c.use_authentication = true
  c.token_model = MyCustomTokenVerifier
end
```

Your `MyCustomTokenVerifier` must be a ruby object that responds to a `locate` class method, and take a single string argument for the api token that needs to be authenticated. The method should return the token string if it's valid, and nil if it's not. You can [read more here](https://github.com/opperator/warden-oauth2#access-token).

This `MyCustomTokenVerifier` could look a few different ways. One way would be to make this a rails model like

```ruby
class MyCustomTokenVerifier < ApplicationModel

  def self.locate(token_string)
    find_by(api_token: token_string)
  end

end
```

Another way would be a simple class that verifies against some configuration option like

```ruby
class MyCustomTokenVerifier

  def self.locate(token_string)
    if token_string == Rails.configuration.x.my_custom_api_token
      token_string
    else
      nil
    end
  end
end
```

## Testing
If you're trying to test controllers, keep in mind that Rails doesn't process the middleware stack for controller tests. This means that the `JkoApi::Middleware` as well as the `JkoApi::Strategies` modules won't exist, and neither will `warden`. You can [read up more here](https://github.com/hassox/warden/issues/117).

My recommendation for testing api endpoints is doing an integration test. With RSpec, just create your `spec/requests` folder, and add your spec for the endpoint you want to test.

If you need access to a mock warden object, you can add

```ruby
require 'jko_api/test_helpers'
include JkoApi::TestHelpers
```

## Debugging notes

If you have a route that matches one of the API routes, and it's listed first, then Rails will match that route first. This might not be what you expected, so put your `JkoApi.routes` near the top to ensure that gets hit first.


## Contributing

1. Fork it ( https://github.com/[my-github-username]/jko_api/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
