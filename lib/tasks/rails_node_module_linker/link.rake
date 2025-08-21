# frozen_string_literal: true

require 'yaml'
require 'fileutils'
require 'rails_node_module_linker/config'

def log_with_emoji(message)
  if RailsNodeModuleLinker.config.use_emojis
    puts message
  else
    # * Removes non-ASCII characters, which includes emojis and the space from the beggining
    puts message.gsub(/[[:^ascii:]]/, '').strip
  end
end

namespace :rails_node_module_linker do
  desc "Symlink full packages from node_modules to #{RailsNodeModuleLinker.config.destination_path}"
  task link: :environment do
    symlinked_node_modules_config = Rails.root.join(
      RailsNodeModuleLinker.config.symlinked_node_modules_config
    )

    # * Ensure the config file exists with a default structure
    unless File.exist?(symlinked_node_modules_config)
      log_with_emoji("🆕 Created missing config file at #{symlinked_node_modules_config}")

      FileUtils.mkdir_p(symlinked_node_modules_config.dirname)
      File.write(symlinked_node_modules_config, { 'packages' => [] }.to_yaml)
    end

    config = YAML.load_file(symlinked_node_modules_config)
    node_modules_to_link = config['packages'] || []

    log_with_emoji('📭 No node modules configured to link.') if node_modules_to_link.empty?

    node_modules_destination_path = Rails.root.join(RailsNodeModuleLinker.config.destination_path)
    FileUtils.mkdir_p(node_modules_destination_path)

    # * Clean up outdated symlinks
    existing_symlinks = Dir.glob(node_modules_destination_path.join('**/*'), File::FNM_DOTMATCH).select do |path|
      File.symlink?(path)
    end
    existing_symlinks.each do |symlink_path|
      relative_path = Pathname.new(symlink_path).relative_path_from(node_modules_destination_path).to_s
      next if node_modules_to_link.include?(relative_path)

      log_with_emoji("🧹 Removing stale symlink: #{symlink_path}")

      FileUtils.rm(symlink_path)
    end

    # * Add or update symlinks from config
    node_modules_to_link.each do |package|
      source = Rails.root.join('node_modules', package)
      destination = node_modules_destination_path.join(package)
      force_link = RailsNodeModuleLinker.config.force_link

      if !source.exist? && !force_link && !destination.symlink?
        log_with_emoji("🚫 Source does not exist: #{source} (skipping)")

        next
      end

      if destination.symlink?
        if File.exist?(destination.readlink)
          log_with_emoji("✅ Already linked: #{destination}")
          next
        elsif !force_link
          log_with_emoji("⛓️‍💥 Broken symlink detected: #{destination} (removing)")

          FileUtils.rm(destination)
          next
        end
      elsif destination.exist?
        log_with_emoji("❌ Destination exists but is not a symlink: #{destination} (skipping)")
        next
      end

      FileUtils.mkdir_p(destination.parent)
      FileUtils.ln_sf(source, destination)

      log_with_emoji("🔗 Linked: #{source} -> #{destination}")
    end
  end

  desc 'Link node module packages before asset precompilation'
  task precompile_hook: :link
end
