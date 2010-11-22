class ActiveRecord::ConnectionAdapters::SQLiteAdapter
  def execute_with_sql_logging(sql, name = nil)
    res = nil
    elapsed = Benchmark.measure do
      res = execute_without_sql_logging(sql, name)
    end
    msec = elapsed.real * 1000
    SqlLogging::Statistics.record_query(sql, name, msec, res)
    res
  end

  alias_method_chain :execute, :sql_logging
end
