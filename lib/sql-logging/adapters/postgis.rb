require 'active_record/connection_adapters/postgis_adapter.rb'
require 'sql-logging/adapters/postgresql.rb'

class ActiveRecord::ConnectionAdapters::PostGISAdapter < ActiveRecord::ConnectionAdapters::PostgreSQLAdapter
end
