# config/initializers/pg_health.rb

PgHealth.configure do |config|
  # Cache duration for database health metric queries (default: 15 seconds)
  # Helps prevent dashboard refreshes from hammering production databases.
  # config.cache_duration = 15.seconds

  # Dead tuple warning & critical threshold percentages
  # config.dead_tuple_warning_threshold = 15
  # config.dead_tuple_critical_threshold = 30

  # Table and Index bloat warning & critical threshold percentages
  # config.bloat_warning_threshold = 20
  # config.bloat_critical_threshold = 35

  # Long-running active query threshold (in seconds)
  # config.long_running_query_threshold = 300

  # Optional database connection pool setting if reading from a replica
  # config.reading_role = :primary_replica
end