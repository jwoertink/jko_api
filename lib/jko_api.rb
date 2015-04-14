require "active_support/all"
require "active_model/railtie"
require "action_controller/railtie"
require "responders"
require "jko_api/version"
require "jko_api/class_descendants_builder"
require "jko_api/constraints"
require "jko_api/controller_helpers"
require "jko_api/middleware"
require "jko_api/request_error"
require "jko_api/responder"
require "jko_api/versioning"
require "jko_api/engine"

module JkoApi
  ACCEPT_HEADER_REGEX = /\Aapplication\/vnd\.api(\.v([0-9]))?\+json\z/

  mattr_accessor :base_controller, instance_accessor: false
  mattr_reader :current_version_number, instance_reader: false

  def self.setup(base_controller)
    ClassDescendantsBuilder.build base_controller, level: max_version_number
    self.base_controller = base_controller
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
end
