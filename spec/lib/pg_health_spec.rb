require 'rails_helper'
require 'pg_health'

RSpec.describe PgHealth do
  describe '.available_databases' do
    it 'returns a formatted hash of only PostgreSQL configurations' do
      # Create mock configurations
      mock_primary = double('Config', name: 'primary', adapter: 'postgresql')
      mock_replica = double('Config', name: 'primary_replica', adapter: 'postgis')
      mock_sqlite  = double('Config', name: 'cache', adapter: 'sqlite3')

      # Stub the Rails config parser to return our mocks
      allow(ActiveRecord::Base.configurations).to receive(:configs_for)
        .with(env_name: Rails.env)
        .and_return([mock_primary, mock_replica, mock_sqlite])

      result = PgHealth.available_databases

      # It should include Postgres/PostGIS and exclude SQLite
      expect(result).to eq({
        "primary" => "Primary",
        "primary_replica" => "Primary Replica"
      })
    end
  end
end