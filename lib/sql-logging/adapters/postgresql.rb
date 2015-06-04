require 'sql-logging/adapters/generic'
require 'active_record/connection_adapters/postgresql_adapter'

class ActiveRecord::ConnectionAdapters::PostgreSQLAdapter
  include SqlLogging::Adapters::Generic

  def exec_delete_with_sql_logging(sql, name = nil, binds = [])
    SqlLogging::Statistics.benchmark(sql, name) do
      exec_delete_without_sql_logging(sql, name, binds)
    end
  end

  alias_method_chain :exec_delete, :sql_logging
end
