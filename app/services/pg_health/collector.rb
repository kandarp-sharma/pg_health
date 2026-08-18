module PgHealth
  class Collector
    attr_reader :spec_name

    def initialize(spec_name: "primary")
      @spec_name = spec_name
    end

    # Executes queries inside the connection context of the target database
    def with_connection
      # In Rails 7/8, retrieve the connection pool corresponding to the spec_name (e.g. "primary", "primary_replica")
      pool = ActiveRecord::Base.connection_handler.retrieve_connection_pool(spec_name) || ActiveRecord::Base.connection_pool

      pool.with_connection do |conn|
        yield conn
      end
    rescue ActiveRecord::ConnectionNotEstablished
      # Fallback to default primary connection if spec lookup fails
      yield ActiveRecord::Base.connection
    end

    # Returns tables ordered by dead tuple count and dead tuple percentage
    def dead_tuples(limit: 20)
      sql = <<~SQL
        SELECT
          schemaname AS schema,
          relname AS table_name,
          n_live_tup AS live_tuples,
          n_dead_tup AS dead_tuples,
          ROUND(
            CASE
              WHEN (n_live_tup + n_dead_tup) > 0
              THEN (n_dead_tup::float / (n_live_tup + n_dead_tup)::float) * 100
              ELSE 0
            END::numeric, 2
          ) AS dead_tuple_percent,
          last_vacuum,
          last_autovacuum,
          last_analyze,
          last_autoanalyze
        FROM pg_stat_user_tables
        ORDER BY n_dead_tup DESC
        LIMIT $1;
      SQL

      exec_query(sql, "Dead Tuples", [limit])
    end

    # Estimates table bloat by comparing physical disk size against estimated data payload size
    def table_bloat(limit: 20)
      sql = <<~SQL
        SELECT
          schemaname AS schema,
          tblname AS table_name,
          pg_size_pretty(tblsize) AS total_size,
          tblsize AS total_size_bytes,
          pg_size_pretty(bloat_size) AS bloat_size,
          bloat_size AS bloat_size_bytes,
          ROUND(bloat_pct::numeric, 2) AS bloat_percent
        FROM (
          SELECT
            schemaname,
            tblname,
            tblsize,
            CASE WHEN tblsize > 0 AND bloat_ratio > 0 THEN (tblsize * bloat_ratio)::bigint ELSE 0 END AS bloat_size,
            CASE WHEN bloat_ratio > 0 THEN bloat_ratio * 100 ELSE 0 END AS bloat_pct
          FROM (
            SELECT
              schemaname,
              tablename AS tblname,
              pg_total_relation_size(quote_ident(schemaname) || '.' || quote_ident(tablename)) AS tblsize,
              GREATEST(0, 1 - (reltuples * 50.0 / GREATEST(pg_total_relation_size(quote_ident(schemaname) || '.' || quote_ident(tablename)), 1))) AS bloat_ratio
            FROM pg_tables
            JOIN pg_class ON pg_class.relname = pg_tables.tablename
            WHERE schemaname NOT IN ('pg_catalog', 'information_schema')
          ) sub1
        ) sub2
        ORDER BY bloat_size_bytes DESC
        LIMIT $1;
      SQL

      exec_query(sql, "Table Bloat", [limit])
    end

    # Lists indexes that have 0 scans, excluding Primary Keys and Unique constraints
    def unused_indexes(limit: 20)
      sql = <<~SQL
        SELECT
          s.schemaname AS schema,
          s.relname AS table_name,
          s.indexrelname AS index_name,
          s.idx_scan AS index_scans,
          pg_size_pretty(pg_relation_size(s.indexrelid)) AS index_size,
          pg_relation_size(s.indexrelid) AS index_size_bytes,
          'DROP INDEX CONCURRENTLY IF EXISTS ' || quote_ident(s.schemaname) || '.' || quote_ident(s.indexrelname) || ';' AS drop_sql
        FROM pg_stat_user_indexes s
        JOIN pg_index i ON i.indexrelid = s.indexrelid
        WHERE s.idx_scan = 0
          AND NOT i.indisunique
          AND NOT i.indisprimary
        ORDER BY pg_relation_size(s.indexrelid) DESC
        LIMIT $1;
      SQL

      exec_query(sql, "Unused Indexes", [limit])
    end

    # Overall Cache Hit Ratio (Target > 99%)
    def cache_hit_ratio
      sql = <<~SQL
        SELECT
          ROUND(
            (sum(blks_hit) * 100.0 / NULLIF(sum(blks_hit + blks_read), 0))::numeric, 2
          ) AS cache_hit_ratio
        FROM pg_stat_database;
      SQL

      result = exec_query(sql, "Cache Hit Ratio").first
      result ? result[:cache_hit_ratio].to_f : 0.0
    end

    private

    def exec_query(sql, name, binds = [])
      with_connection do |conn|
        raw_result = conn.exec_query(sql, "PgHealth #{name}", binds)
        raw_result.to_a.map(&:symbolize_keys)
      end
    rescue ActiveRecord::StatementInvalid => e
      Rails.logger.error("[PgHealth] Query failed for #{name} on #{spec_name}: #{e.message}")
      []
    end
  end
end