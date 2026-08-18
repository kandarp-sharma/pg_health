require 'rails_helper'

RSpec.describe PgHealth::Collector do
  describe '#with_connection' do
    let(:mock_pool) { instance_double(ActiveRecord::ConnectionAdapters::ConnectionPool) }
    let(:mock_connection) { instance_double(ActiveRecord::ConnectionAdapters::PostgreSQLAdapter) }

    it 'uses the specific connection pool when a valid spec_name is provided' do
      collector = PgHealth::Collector.new(spec_name: 'primary_replica')

      # Stub the connection handler to return our mock pool when 'primary_replica' is requested
      allow(ActiveRecord::Base.connection_handler).to receive(:retrieve_connection_pool)
        .with('primary_replica')
        .and_return(mock_pool)

      # Ensure the mock pool yields our mock connection
      expect(mock_pool).to receive(:with_connection).and_yield(mock_connection)

      # Execute the block and verify the connection passed down is the mock
      collector.send(:with_connection) do |conn|
        expect(conn).to eq(mock_connection)
      end
    end

    it 'falls back to the default connection pool if spec_name is invalid or missing' do
      collector = PgHealth::Collector.new(spec_name: 'non_existent_db')

      # 1. Allow Rails internals to call this method with other arguments normally
      allow(ActiveRecord::Base.connection_handler).to receive(:retrieve_connection_pool).and_call_original

      # 2. But specifically return nil when our invalid db is requested
      allow(ActiveRecord::Base.connection_handler).to receive(:retrieve_connection_pool)
        .with('non_existent_db')
        .and_return(nil)

      # 3. Stub the default connection pool behavior
      allow(ActiveRecord::Base).to receive(:connection_pool).and_return(mock_pool)
      expect(mock_pool).to receive(:with_connection).and_yield(mock_connection)

      collector.send(:with_connection) do |conn|
        expect(conn).to eq(mock_connection)
      end
    end
  end
end