module PgHealth
  class DashboardController < ApplicationController
    def index
      @databases = PgHealth.available_databases
      @selected_db = params[:db].presence && @databases.key?(params[:db]) ? params[:db] : @databases.keys.first || "primary"

      collector = PgHealth::Collector.new(spec_name: @selected_db)

      @cache_hit_ratio = collector.cache_hit_ratio
      @dead_tuples     = collector.dead_tuples
      @table_bloat     = collector.table_bloat
      @unused_indexes  = collector.unused_indexes
    end
  end
end