module JkoApi
  module TestHelpers
    extend ActiveSupport::Concern

    included do
      include Warden::Test::Mock
    end
  end
end
