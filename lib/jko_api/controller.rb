module JkoApi
  module Controller
    extend ActiveSupport::Concern

    included do
      include JkoApi::ControllerHelpers
      skip_authentication # TODO: make this configurable

      self.responder = JkoApi::Responder
      respond_to :json
    end

  private

    def render_json_errors(status, message = status)
      render json: JkoApi::RequestError[status, message], status: status
    end
  end
end
