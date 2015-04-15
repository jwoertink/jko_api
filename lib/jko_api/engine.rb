require 'rails/railtie'

module JkoApi
  class Engine < ::Rails::Engine
    initializer "jko_api.configure_rails_initialization" do |app|
      app.middleware.use JkoApi::Middleware
    end
  end
end
