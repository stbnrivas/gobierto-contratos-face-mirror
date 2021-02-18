# frozen_string_literal: true

require_relative "boot"

def m(params = {})
  Hashie::Mash.new(params)
end

require "rails"
require "active_model/railtie"
require "active_record/railtie"
require "rails/test_unit/railtie"
require "action_controller/railtie"
require "action_view/railtie"

# External dependencies
require "csv"
require "ine"

Bundler.require(*Rails.groups)

module OpenLicitaciones
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    config.active_record.schema_format = :sql

    required_paths = [
      "#{config.root}/lib",
    ]

    config.autoload_paths += required_paths
    config.eager_load_paths += required_paths
  end
end
