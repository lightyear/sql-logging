require 'active_record/connection_adapters/postgresql_adapter'

class ActiveRecord::ConnectionAdapters::PostgreSQLAdapter
  def execute_with_sql_logging(sql, *args)
    result = nil
    elapsed = Benchmark.measure do
      result = execute_without_sql_logging(sql, *args)
    end
    msec = elapsed.real * 1000
    if result.respond_to?(:rows)
      SqlLogging::Statistics.record_query(sql, args.first, msec, result.rows)
    else
      SqlLogging::Statistics.record_query(sql, args.first, msec, result)
    end
    result
  end
  
  def exec_query_with_sql_logging(sql, *args)
    result = nil
    elapsed = Benchmark.measure do
      result = exec_query_without_sql_logging(sql, *args)
    end
    msec = elapsed.real * 1000
    if result.respond_to?(:rows)
      SqlLogging::Statistics.record_query(sql, args.first, msec, result.rows)
    else
      SqlLogging::Statistics.record_query(sql, args.first, msec, result)
    end
    result
  end
  
  def exec_delete_with_sql_logging(sql, *args)
    result = nil
    elapsed = Benchmark.measure do
      result = exec_delete_without_sql_logging(sql, *args)
    end
    msec = elapsed.real * 1000
    SqlLogging::Statistics.record_query(sql, args.first, msec, result)
    result
  end
  
  alias_method_chain :execute, :sql_logging
  alias_method_chain :exec_query, :sql_logging
  alias_method_chain :exec_delete, :sql_logging
end
