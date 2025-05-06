# frozen_string_literal: true

require 'rails'
require 'rails_node_module_linker'

class RailsNodeModuleLinker::Railtie < Rails::Railtie
  railtie_name :rails_node_module_linker

  rake_tasks do
    path = File.expand_path(__dir__)
    Dir.glob("#{path}/tasks/**/*.rake").each { |f| load f }
  end

  initializer 'rails_node_module_linker.insert_middleware' do |app|
    if Rails.env.development?
      app.middleware.insert_before ActionDispatch::Static, RailsNodeModuleLinker::Middleware
      Rails.logger.info '[rails_node_module_linker] Middleware inserted'
    else
      Rails.logger.info '[rails_node_module_linker] Middleware skipped'
    end
  end
end
