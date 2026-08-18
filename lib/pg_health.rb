require "pg_health/version"
require "pg_health/engine"

module PgHealth
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