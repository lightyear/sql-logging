module ActiveRecord::ConnectionAdapters
  module ExecuteWithSqlLogging
    def execute(sql, name = nil)
      res = nil
      elapsed = Benchmark.measure do
        res = super(sql, name)
      end
      msec = elapsed.real * 1000
      SqlLogging::Statistics.record_query(sql, name, msec, res)
      res
    end
  end

  class SQLiteAdapter
    prepend ExecuteWithSqlLogging
  end
end
