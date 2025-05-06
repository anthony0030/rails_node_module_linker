class MissingNodeModuleHandler
  def initialize(app)
    @app = app
  end

  def call(env)
    path = env["PATH_INFO"]
    query = Rack::Utils.parse_query(env["QUERY_STRING"])
    config_file_path = RailsNodeModuleLinker.config.config_file_path

    if path.start_with?("/node_modules/")
      status, _headers, _body = @app.call(env)
      if status == 404
        package = extract_package(path)

        # * Ensure the config directory exists
        FileUtils.mkdir_p(config_file_path.dirname)

        # * Load existing config or initialize a new one
        config = File.exist?(config_file_path) ? YAML.load_file(config_file_path) : { "packages" => [] }

        # * Add the package if not already listed
        config["packages"] = (config["packages"] | [package]).sort

        # * Save the updated config
        File.write(config_file_path, config.to_yaml)

        # * Call the rake task to create the symlink
        system("bin/rails assets:link_node_module_packages")

        return redirect_to_newly_linked_module(path)
      end
    end

    @app.call(env)
  end

  private
    def extract_package(path)
      segments = path.split("/")

      return nil unless segments[1] == "node_modules"

      if segments[2].start_with?("@")
        "#{segments[2]}/#{segments[3]}"
      else
        segments[2]
      end
    end

    def redirect_to_newly_linked_module(path)
      [
        302,
        { "Location" => path },
        []
      ]
    end
end
