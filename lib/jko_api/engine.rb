require 'rails/railtie'

module JkoApi
  class Engine < ::Rails::Engine
    initializer "jko_api.configure_rails_initialization" do |app|
      app.middleware.use JkoApi::Middleware

      if JkoApi.configuration&.authenticate?
        app.middleware.use "JkoApi::Strategies::#{JkoApi.configuration.strategy.to_s.capitalize}".constantize
      end
    end
  end
end
