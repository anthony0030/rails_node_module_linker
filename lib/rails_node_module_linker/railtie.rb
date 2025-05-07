# frozen_string_literal: true

require 'rails'
require 'rails_node_module_linker'

class RailsNodeModuleLinker::Railtie < Rails::Railtie
  railtie_name :rails_node_module_linker

  # TODO: make this changeable via setting
  # * Hardcoded toggle for before/after
  PRECOMPILE_HOOK_POSITION = :before # ? or :after

  rake_tasks do
    path = File.expand_path(__dir__)
    Dir.glob("#{path}/tasks/**/*.rake").each { |f| load f }

    Rake::Task.define_task(:environment)

    case PRECOMPILE_HOOK_POSITION
    when :before
      Rake::Task['assets:precompile'].enhance(['rails_node_module_linker:precompile_hook'])
    when :after
      Rake::Task['assets:precompile'].enhance do
        Rake::Task['rails_node_module_linker:precompile_hook'].invoke
      end
    end
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
