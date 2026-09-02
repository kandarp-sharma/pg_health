module PgHealth
  class DashboardController < ApplicationController
    def overview_dashboard
      @databases = PgHealth.available_databases
      @selected_db = params[:db].presence && @databases.key?(params[:db]) ? params[:db] : @databases.keys.first || "primary"

      collector = PgHealth::Collector.new(spec_name: @selected_db)

      @cache_hit_ratio = collector.cache_hit_ratio
      @dead_tuples     = collector.dead_tuples
      @table_bloat     = collector.table_bloat
      @unused_indexes  = collector.unused_indexes
    end

    def table_health
    end

    def storage_bloat
    end

    def index_tuning
    end

    def locks_activity
    end
  end
end