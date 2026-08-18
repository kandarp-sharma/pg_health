require_relative "lib/pg_health/version"

Gem::Specification.new do |spec|
  spec.name        = "pg_health"
  spec.version     = PgHealth::VERSION
  spec.authors     = [ "Kandarp Sharma" ]
  spec.email       = [ "sharma.kandarp24@gmail.com" ]
  spec.homepage    = "TODO"
  spec.summary     = "TODO: Summary of PgHealth."
  spec.description = "TODO: Description of PgHealth."
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
  spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.required_ruby_version = ">= 3.1.0"

  spec.add_dependency "rails", ">= 7.0.0"
  spec.add_dependency "pg", ">= 1.1"
end
