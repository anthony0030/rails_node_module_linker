# frozen_string_literal: true

class RailsNodeModuleLinker::Config
  attr_accessor :config_file_path, :use_emojis

  def initialize
    # * Default configuration values
    @config_file_path = Rails.root.join('config/symlinked_node_modules.yml')
    @use_emojis = true

    # TODO: make desitination folder customizable
    # TODO: make source folder customizable
    # TODO: make middleware enablement configurable
  end
end
