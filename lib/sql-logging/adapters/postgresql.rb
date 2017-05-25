require 'active_record/connection_adapters/postgresql_adapter'

module ActiveRecord::ConnectionAdapters
  module ExecuteWithSqlLogging
    def execute(sql, *args)
      result = nil
      elapsed = Benchmark.measure do
        result = super(sql, *args)
      end
      msec = elapsed.real * 1000
      if result.respond_to?(:rows)
        SqlLogging::Statistics.record_query(sql, args.first, msec, result.rows)
      else
        SqlLogging::Statistics.record_query(sql, args.first, msec, result)
      end
      result
    end
  end

  module ExecQueryWithSqlLogging
    def exec_query(sql, *args)
      result = nil
      elapsed = Benchmark.measure do
        result = super(sql, *args)
      end
      msec = elapsed.real * 1000
      if result.respond_to?(:rows)
        SqlLogging::Statistics.record_query(sql, args.first, msec, result.rows)
      else
        SqlLogging::Statistics.record_query(sql, args.first, msec, result)
      end
      result
    end
  end

  module ExecDeleteWithSqlLogging
    def exec_delete(sql, *args)
      result = nil
      elapsed = Benchmark.measure do
        result = super(sql, *args)
      end
      msec = elapsed.real * 1000
      SqlLogging::Statistics.record_query(sql, args.first, msec, result)
      result
    end
  end

  class PostgreSQLAdapter
    prepend ExecuteWithSqlLogging
    prepend ExecQueryWithSqlLogging
    prepend ExecDeleteWithSqlLogging
  end
end
