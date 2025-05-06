require 'yaml'
require 'fileutils'

def log_with_emoji(message)
  if RailsNodeModuleLinker.config.use_emojis
    puts message.to_s
  else
    puts message.gsub(/[[:^ascii:]]/, '').strip # * Removes non-ASCII characters, which includes emojis and the space from the beggining
  end
end

namespace :rails_node_module_linker do
  desc "Symlink full packages from node_modules to public/node_modules"
  task :link => :environment do

    # * Ensure the config file exists with a default structure
    unless File.exist?(@config_file_path)
      log_with_emoji("🆕 Created missing config file at #{@config_file_path}")

      FileUtils.mkdir_p(@config_file_path.dirname)
      File.write(@config_file_path, { "packages" => [] }.to_yaml)
    end

    config = YAML.load_file(@config_file_path)
    node_modules_to_link = config["packages"] || []

    if node_modules_to_link.empty?
      log_with_emoji("📭 No node modules configured to link.")
    end

    public_node_modules = Rails.root.join("public/node_modules")
    FileUtils.mkdir_p(public_node_modules)

    # * Clean up outdated symlinks
    existing_symlinks = Dir.glob(public_node_modules.join("**/*"), File::FNM_DOTMATCH).select { |path| File.symlink?(path) }
    existing_symlinks.each do |symlink_path|
      relative_path = Pathname.new(symlink_path).relative_path_from(public_node_modules).to_s
      unless node_modules_to_link.include?(relative_path)
        log_with_emoji("🧹 Removing stale symlink: #{symlink_path}")

        FileUtils.rm(symlink_path)
      end
    end

    # * Add or update symlinks from config
    node_modules_to_link.each do |package|
      source = Rails.root.join("node_modules", package)
      destination = public_node_modules.join(package)

      unless source.exist?
        log_with_emoji("🚫 Source does not exist: #{source} (skipping)")

        next
      end

      if destination.symlink?
        if File.exist?(destination.readlink)
          log_with_emoji("✅ Already linked: #{destination}")
          next
        else
          log_with_emoji("⚠ Broken symlink detected: #{destination} (removing)")

          FileUtils.rm(destination)
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

  task precompile: :link_node_module_packages # TODO test that this actually runs
end
