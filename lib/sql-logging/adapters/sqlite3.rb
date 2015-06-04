require 'sql-logging/adapters/generic'
require 'active_record/connection_adapters/sqlite3_adapter'

class ActiveRecord::ConnectionAdapters::SQLite3Adapter
  include SqlLogging::Adapters::Generic
end
