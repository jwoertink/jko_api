module JkoApi
  class Configuration

    attr_accessor :base_controller, :api_namespace

    def initialize
      @base_controller = Api::ApplicationController
      @api_namespace = 'api'
    end

  end
end
