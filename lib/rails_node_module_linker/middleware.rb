# frozen_string_literal: true

require 'rails_node_module_linker/config'

class RailsNodeModuleLinker::Middleware
  def initialize(app)
    @app = app
  end

  def call(env)
    path = env['PATH_INFO']
    Rack::Utils.parse_query(env['QUERY_STRING'])
    symlinked_node_modules_config = Rails.root.join(
      RailsNodeModuleLinker.config.symlinked_node_modules_config
    )

    if path.start_with?('/node_modules/')
      status, _headers, _body = @app.call(env)
      if status == 404
        package = extract_package(path)

        # * Ensure the config directory exists
        FileUtils.mkdir_p(symlinked_node_modules_config.dirname)

        # * Load existing config or initialize a new one
        config = File.exist?(symlinked_node_modules_config) ? YAML.load_file(symlinked_node_modules_config) : { 'packages' => [] }

        # * Add the package if not already listed
        config['packages'] = (config['packages'] | [package]).sort

        # * Save the updated config
        File.write(symlinked_node_modules_config, config.to_yaml)

        # * Call the rake task to create the symlink
        system('bin/rails rails_node_module_linker:link')

        return redirect_to_newly_linked_module(path)
      end
    end

    @app.call(env)
  end

  private

  def extract_package(path)
    segments = path.split('/')

    return nil unless segments[1] == 'node_modules'

    if segments[2].start_with?('@')
      "#{segments[2]}/#{segments[3]}"
    else
      segments[2]
    end
  end

  def redirect_to_newly_linked_module(path)
    [
      302,
      { 'Location' => path },
      []
    ]
  end
end
