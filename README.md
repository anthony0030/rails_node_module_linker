# RailsNodeModuleLinker

Helps expose selected node_modules into the public directory for use in Rails apps that have transitioned from Sprockets to Propshaft.

## Installation

Install the gem and add to the application's Gemfile by executing:

```bash
bundle add rails_node_module_linker
```

If bundler is not being used to manage dependencies, install the gem by executing:

```bash
gem install rails_node_module_linker
```

## Usage

```ruby
# config/initializers/rails_node_module_linker.rb

Rails.application.config.to_prepare do
  RailsNodeModuleLinker.config.config_file_path = Rails.root.join("config/symlinked_node_modules.yml")
  RailsNodeModuleLinker.config.use_emojis = true
end
```

### Rake Tasks

#### Link Node Modules

Run the following command to link selected node_modules to the public directory:

```bash
rails rails_node_module_linker:link
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub [here](https://github.com/anthony0030/rails_node_module_linker). This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/anthony0030/rails_node_module_linker/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the RailsNodeModuleLinker project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/anthony0030/rails_node_module_linker/blob/master/CODE_OF_CONDUCT.md).
