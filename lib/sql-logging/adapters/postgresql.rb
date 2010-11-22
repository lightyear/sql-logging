require 'active_record/connection_adapters/postgresql_adapter'

class ActiveRecord::ConnectionAdapters::PostgreSQLAdapter
  def execute_with_sql_logging(sql, name = nil)
    result = nil
    elapsed = Benchmark.measure do
      result = execute_without_sql_logging(sql, name)
    end
    msec = elapsed.real * 1000
    if result.respond_to?(:rows)
      SqlLogging::Statistics.record_query(sql, name, msec, result.rows)
    else
      SqlLogging::Statistics.record_query(sql, name, msec, result)
    end
    result
  end
  
  alias_method_chain :execute, :sql_logging
end
