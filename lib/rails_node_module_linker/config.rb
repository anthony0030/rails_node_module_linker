# frozen_string_literal: true

class RailsNodeModuleLinker::Config
  attr_accessor :symlinked_node_modules_config, :destination_path, :force_link, :use_emojis

  def initialize
    # * Default configuration values
    @symlinked_node_modules_config = 'config/symlinked_node_modules.yml'
    @destination_path = 'public/node_modules'
    @force_link = false
    @use_emojis = true

    # TODO: make source folder customizable
    # TODO: make middleware enablement configurable
  end
end
