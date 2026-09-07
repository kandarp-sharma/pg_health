require_relative "lib/pg_health/version"

Gem::Specification.new do |spec|
  spec.name        = "pg_health"
  spec.version     = PgHealth::VERSION
  spec.authors     = [ "Kandarp Sharma" ]
  spec.email       = [ "sharma.kandarp24@gmail.com" ]
  spec.homepage    = "https://github.com/kandarp-sharma/pg_health"
  spec.summary     = "PostgreSQL health monitoring dashboard."
  spec.description = "A lightweight mountable dashboard for tracking PostgreSQL table bloat, dead tuples, and query health."
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  # spec.metadata["source_code_uri"] = "https://github.com/kandarp-sharma/pg_health"
  # spec.metadata["changelog_uri"]   = "https://github.com/kandarp-sharma/pg_health/blob/main/CHANGELOG.md"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.required_ruby_version = ">= 3.1.0"

  spec.add_dependency "rails", ">= 7.0.0"
  spec.add_dependency "pg", ">= 1.1"

  spec.add_development_dependency "rspec-rails", ">= 6.0"
  spec.add_development_dependency "factory_bot_rails"
end
