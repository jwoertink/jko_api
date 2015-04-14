module JkoApi
  module Constraints
    def self.matches?(request)
      request.headers['Accept'] &&
      request.headers['Accept'].match(ACCEPT_HEADER_REGEX) &&
      request.subdomain.include?('api') &&
      ::JkoApi.current_version_number.present?
    end
  end
end
