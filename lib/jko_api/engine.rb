require 'rails/railtie'

module JkoApi
  class Engine < ::Rails::Engine
    initializer "jko_api.configure_rails_initialization" do |app|
      app.middleware.use JkoApi::Middleware, only: proc { |env| 
        puts "ENVVVVVV", env.inspect
        env['Accept'] && env['Accept'].include?('application/vnd.api') }

      if JkoApi.configuration&.authenticate?
        app.middleware.use "JkoApi::Strategies::#{JkoApi.configuration.strategy.to_s.capitalize}".constantize, only: proc { |env| env['Accept'] && env['Accept'].include?('application/vnd.api')  }
      end
    end
  end
end
