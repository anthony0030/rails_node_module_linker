# frozen_string_literal: true

require 'rails_node_module_linker'
require 'rails'

module MyGem
  class Railtie < Rails::Railtie
    railtie_name :rails_node_module_linker

    rake_tasks do
      path = File.expand_path(__dir__)
      Dir.glob("#{path}/tasks/**/*.rake").each { |f| load f }
    end
  end
end
