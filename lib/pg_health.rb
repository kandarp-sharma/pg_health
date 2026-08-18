require "pg_health/version"
require "pg_health/engine"

module PgHealth
  # Returns a hash of database names/roles configured for PostgreSQL
  # e.g. { "primary" => "Primary", "primary_replica" => "Primary Replica" }
  def self.available_databases
    configs = ActiveRecord::Base.configurations.configs_for(env_name: Rails.env)

    pg_configs = configs.select do |config|
      config.adapter.to_s.include?("postgresql") || config.adapter.to_s.include?("postgis")
    end

    pg_configs.each_with_object({}) do |config, hash|
      # 'config.name' is the correct method in Rails (e.g., "primary")
      key = config.name
      label = key.humanize.titleize
      hash[key] = label
    end
  end

  class Configuration
    attr_accessor :cache_duration,
                  :dead_tuple_warning_threshold,
                  :dead_tuple_critical_threshold,
                  :bloat_warning_threshold,
                  :bloat_critical_threshold,
                  :long_running_query_threshold,
                  :reading_role

    def initialize
      @cache_duration = 15
      @dead_tuple_warning_threshold = 15
      @dead_tuple_critical_threshold = 30
      @bloat_warning_threshold = 20
      @bloat_critical_threshold = 35
      @long_running_query_threshold = 300
      @reading_role = :writing
    end
  end

  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end
  end
end