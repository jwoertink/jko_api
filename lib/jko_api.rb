require "active_support/all"
require "active_model/railtie"
require "action_controller/railtie"
require "responders"
require "warden-oauth2"
require "jko_api/version"
require "jko_api/strategies"
require "jko_api/class_descendants_builder"
require "jko_api/constraints"
require "jko_api/controller"
require "jko_api/controller_helpers"
require "jko_api/middleware"
require "jko_api/request_error"
require "jko_api/responder"
require "jko_api/versioning"
require "jko_api/configuration"
require "jko_api/util"
require "jko_api/engine"


module JkoApi
  ACCEPT_HEADER_REGEX = /\Aapplication\/vnd\.api(\.v([0-9]))?\+json\z/

  mattr_accessor :configuration, instance_accessor: false
  mattr_accessor :auth_initializer, instance_accessor: false
  mattr_reader :current_version_number, instance_reader: false
  @@versioning = nil

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
    self.configuration
  end

  def self.complete_setup(base_controller)
    if Rails.version.to_i < 5
      Util.stupid_hack!
    end
    ClassDescendantsBuilder.build(base_controller, upto: max_version_number)
    @@auth_initializer.call
  end

  def self.activated?
    current_version_number.present? && current_version_number > 0
  end

  def self.reset
    self.current_version_number = nil
  end

  def self.current_version_number=(version_number)
    @@current_version_number = version_number.to_i
  end

  def self.min_version_number
    versioning.min_version_number
  end

  def self.max_version_number
    versioning.max_version_number
  end

  def self.versioning
    @@versioning || raise('call `.versions` first')
  end

  def self.versions(context, &block)
    @@versioning = Versioning.new(context, &block)
  end

  def self.routes(context, &block)
    context.scope(module: JkoApi.configuration.api_namespace, constraints: JkoApi::Constraints, defaults: {format: :json}) do
      JkoApi.versions(context, &block)
    end
    complete_setup(configuration.base_controller)
    context
  end

  def self.auth_setup(&block)
    self.auth_initializer = block
  end
end
