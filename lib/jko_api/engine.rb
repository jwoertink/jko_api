require 'rails/railtie'

module JkoApi
  class Engine < ::Rails::Engine
    initializer "jko_api.configure_rails_initialization" do |app|
      app.middleware.use JkoApi::Middleware, only: proc { |env|
        env['HTTP_ACCEPT'] && env['HTTP_ACCEPT'].include?('application/vnd.api') }

      if JkoApi.configuration&.authenticate?
        app.middleware.use "JkoApi::Strategies::#{JkoApi.configuration.strategy.to_s.capitalize}".constantize, only: proc { |env| env['HTTP_ACCEPT'] && env['HTTP_ACCEPT'].include?('application/vnd.api')  }
      end
    end
  end
end
