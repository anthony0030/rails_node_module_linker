module RailsNodeModuleLinker
  class Config
    attr_accessor :config_file_path, :use_emojis

    def initialize
      # Default configuration values
      @config_file_path = Rails.root.join("config/symlinked_node_modules.yml")
      @use_emojis = true  # Default value for use_emojis
    end
  end
end
