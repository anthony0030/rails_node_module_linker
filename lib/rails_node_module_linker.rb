# frozen_string_literal: true

require_relative "rails_node_module_linker/version"
require_relative "rails_node_module_linker/railtie"
require_relative "rails_node_module_linker/config"
require_relative "rails_node_module_linker/middleware"

# Load tasks
Dir[File.expand_path("../tasks/**/*.rake", __FILE__)].each { |f| load f }

module RailsNodeModuleLinker
  # Configuration accessor for users to access and modify settings
  mattr_accessor :config

  class Engine < ::Rails::Engine
    # Initialize default configuration
    initializer "rails_node_module_linker.config" do
      RailsNodeModuleLinker.config ||= RailsNodeModuleLinker::Config.new
    end

    # Add middleware
    config.middleware.use RailsNodeModuleLinker::MissingNodeModuleHandler
  end
end
