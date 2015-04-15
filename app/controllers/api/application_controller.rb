class Api::ApplicationController < ActionController::Base
  include JkoApi::ControllerHelpers
  skip_authentication # TODO: make this configurable

  self.responder = JkoApi::Responder
  respond_to :json

  private

  def render_json_errors(status, message = status)
    render json: JkoApi::RequestError[status, message], status: status
  end
end
