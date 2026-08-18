require "rails/generators/base"

module PgHealth
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      desc "Creates a PgHealth initializer file and prints route mounting instructions."

      def copy_initializer
        template "initializer.rb", "config/initializers/pg_health.rb"
      end

      def show_post_install
        say <<~MSG, :green

          ===============================================================================
          PgHealth successfully installed!

          Created: config/initializers/pg_health.rb

          Next step: Mount the engine in `config/routes.rb` with your preferred auth setup:

          1. Devise (Admin Role):
             authenticate :user, ->(u) { u.admin? } do
               mount PgHealth::Engine => "/pg_health"
             end

          2. Rails 8 Native Authentication:
             constraints ->(req) { Session.find_by(id: req.cookie_jar.signed[:session_id])&.user&.admin? } do
               mount PgHealth::Engine => "/pg_health"
             end

          3. Basic Authentication (Sidekiq Style):
             PgHealth::Engine.use Rack::Auth::Basic do |username, password|
               ActiveSupport::SecurityUtils.secure_compare(username, ENV.fetch("PG_HEALTH_USER", "admin")) &
                 ActiveSupport::SecurityUtils.secure_compare(password, ENV.fetch("PG_HEALTH_PASS", "secret"))
             end
             mount PgHealth::Engine => "/pg_health"

          ===============================================================================
        MSG
      end
    end
  end
end