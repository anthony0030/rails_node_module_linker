# Changelog

## [0.2.1] - 2025-08-21

- Adds force_link setting
- Fixes linking bug of broken symlink
- Improves emoji selection in console output
- Adds ruby Version file

## [0.2.0] - 2025-05-17

- Adds ability to change the `destination_path`
- renames config_file_path to symlinked_node_modules_config
- BREAKING removes need to add Rails.root.join in the config

## [0.1.1] - 2025-05-07

- Fixes precompile hook

## [0.1.0] - 2025-05-06

- Initial release
- Links selected node_modules to `public/` for use with Propshaft
