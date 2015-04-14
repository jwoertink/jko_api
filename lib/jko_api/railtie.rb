require 'rails/railtie'

module JkoApi
  class Railtie < ::Rails::Railtie
    config.middleware.use 'JkoApi::Middleware'
    config.after_initialize do
      JkoApi.setup Api::ApplicationController
    end
  end
end
