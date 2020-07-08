module JkoApi
  class Util

    # This was a hack needed in rails 4.2
    # I'm keeping the code for backwards compatibility (for now)
    def self.stupid_hack!
      Rails.application.reload_routes!
      eager_load_api_controllers
    end

    def self.eager_load_api_controllers
      [Rails.root.join('app', 'controllers')].each do |load_path|
        matcher = /\A#{Regexp.escape(load_path.to_s)}\/(.*)\.rb\Z/
        Dir.glob("#{load_path}/#{JkoApi.configuration.api_namespace}/**/*.rb").sort.each do |file|
          require_dependency file.sub(matcher, '\1')
        end
      end
    end
  end
end
