require 'sql-logging/connection_adapters/generic'
require 'active_record/connection_adapters/sqlite_adapter'

class ActiveRecord::ConnectionAdapters::SQLiteAdapter
  include SqlLogging::Adapters::Generic
end
