module JkoApi
  class Configuration

    attr_accessor :base_controller, :api_namespace, :use_authentication
    attr_reader :strategy

    def initialize
      @base_controller = ApiApplicationController
      @api_namespace = 'api'
      @use_authentication = false
      @strategy = :bearer
    end

  end
end
