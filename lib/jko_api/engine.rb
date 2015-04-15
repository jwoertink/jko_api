require 'rails/railtie'

module JkoApi
  class Engine < ::Rails::Engine
    initializer "jko_api.configure_rails_initialization" do |app|
      app.middleware.use JkoApi::Middleware
    end
    config.to_prepare do
      Rails.application.reload_routes!
      JkoApi.setup Api::ApplicationController
    end
  end
end
