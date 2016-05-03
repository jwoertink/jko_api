module JkoApi
  module Strategies
    class Bearer

      def initialize(app, options ={})
        @app = app
        @only = options[:only]
        @mgr = Warden::Manager.new(@app, options) do |config|
          config.strategies.add :bearer, Warden::OAuth2::Strategies::Bearer
          config.default_strategies :bearer
          config.failure_app = Warden::OAuth2::FailureApp
        end

        @mgr
      end

      def call(env)
        if @only && @only.call(env)
          @mgr.call(env)
        else
          @app.call(env)
        end
      end
    end
  end
end
