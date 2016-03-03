module JkoApi
  class Configuration

    attr_accessor :base_controller, :api_namespace, :use_authentication, :token_model

    def initialize
      @base_controller = ApiApplicationController
      @api_namespace = 'api'
      @use_authentication = false
      @strategy = :bearer
    end

    def authenticate?
      use_authentication
    end

    def strategy
      @strategy.to_s.inquiry
    end

  end
end
