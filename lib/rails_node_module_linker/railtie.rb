# frozen_string_literal: true

require 'rails'
require 'rails_node_module_linker'

module RailsNodeModuleLinker
  class Railtie < Rails::Railtie
    railtie_name :rails_node_module_linker

    rake_tasks do
      path = File.expand_path(__dir__)
      Dir.glob("#{path}/tasks/**/*.rake").each { |f| load f }
    end

    initializer "rails_node_module_linker.insert_middleware" do |app|
      app.middleware.insert_before ActionDispatch::Static, RailsNodeModuleLinker::Middleware
    end
  end
end
