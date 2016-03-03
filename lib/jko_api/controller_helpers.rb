module JkoApi
  module ControllerHelpers
    extend ActiveSupport::Concern

    included do
      class_attribute :authenticated
      self.authenticated = false
      append_before_action do
        unless authenticated
          render(json: {error: 'Authentication Failed'}, status: 401)
        end
      end
    end

    class_methods do
      def authenticate(*args)
        options, model_classes = args.extract_options!, args
        options.reverse_merge! optional: false
        # This is for use with Devise.
        # TODO: make this configurable
        # options[:fallback_to_devise] = !options.delete(:optional)
        # model_classes.each do |model_class|
        #   acts_as_token_authentication_handler_for model_class, options
        # end
        self.authenticated = true
      end

      def skip_authentication
        self.authenticated = true
      end
    end
  end
end
