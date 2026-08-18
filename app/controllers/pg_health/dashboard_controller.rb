module PgHealth
  class DashboardController < ApplicationController
    def index
      @database_size = ActiveRecord::Base.connection.select_value(
        "SELECT pg_size_pretty(pg_database_size(current_database()))"
      )
    end
  end
end