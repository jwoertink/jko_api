module JkoApi
  class Configuration

    attr_accessor :base_controller

    def initialize
      @base_controller = Api::ApplicationController
    end

  end
end
