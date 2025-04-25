# frozen_string_literal: true

require "rails/railtie"

module RailsNodeModuleLinker
  class Railtie < ::Rails::Railtie
    rake_tasks do
      load "rails_node_module_linker/tasks/link.rake"
    end
  end
end
