module JkoApi
  class Responder < ActionController::Responder
    protected

    def display(model, *args)
      options[:user]        ||= controller.current_user
      options[:wrap]        ||= controller.wrap
      options[:representer] ||= controller.representer

      if first_model = Array.wrap(model).first
        options[:wrap] ||= first_model.class.table_name
      end

      options[:wrap] || raise('set the `wrap` in the controller')
      representer = options[:representer] || first_model.representer

      if Array === model || ActiveRecord::Relation === model
        representer = representer.for_collection
      end

      super representer.prepare(model), *args
    end

    def api_behavior
      raise MissingRenderer.new(format) unless has_renderer?

      if put?
        display resource, status: :ok, location: api_location
      elsif delete?
        display resource, status: :ok
      else
        super
      end
    end

    def api_location
      if !options[:location] && controller.controller_name.starts_with?('user_')
        options[:location] = user_resource_api_location
      else
        super
      end
    end

    def user_resource_api_location
      url_helpers = Rails.application.routes.url_helpers
      url_method = controller.controller_name
      url_method = url_method.singularize unless resources.many?
      url_method = url_method + '_url'
      if resources.many?
        url_helpers.public_send url_method
      else
        url_helpers.public_send url_method, resource
      end
    end

    def json_resource_errors
      resource.errors
    end
  end
end
