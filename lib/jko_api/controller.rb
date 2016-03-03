module JkoApi
  module Controller
    extend ActiveSupport::Concern

    included do
      include JkoApi::ControllerHelpers

      if JkoApi.configuration&.use_authentication
        prepend_before_action :authenticate!
      else
        skip_authentication
      end

      self.responder = JkoApi::Responder
      respond_to :json
    end

  private

    def render_json_errors(status, message = status)
      render json: JkoApi::RequestError[status, message], status: status
    end

    def warden
      request.env['warden']
    end

    def authenticate!
      token = warden.authenticate!
      self.authenticated = !!token
    end
  end
end
