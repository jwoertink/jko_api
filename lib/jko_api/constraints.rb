module JkoApi
  module Constraints
    def self.matches?(request)
      request.headers['Accept'] &&
      request.headers['Accept'].match(ACCEPT_HEADER_REGEX) &&
      ::JkoApi.current_version_number.present?
      # TODO: add condition config for specific subdomain
    end
  end
end
