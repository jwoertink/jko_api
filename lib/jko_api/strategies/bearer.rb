module JkoApi
  module Strategies
    class Bearer

      def initialize(app, options ={})
        @mgr = Warden::Manager.new(app, options) do |config|
          config.strategies.add :bearer, Warden::OAuth2::Strategies::Bearer
          config.default_strategies :bearer
          config.failure_app = Warden::OAuth2::FailureApp
        end

        @mgr
      end

      def call(env)
        @mgr.call(env)
      end
    end
  end
end
