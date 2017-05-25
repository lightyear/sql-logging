require 'active_record/connection_adapters/mysql2_adapter'

module ActiveRecord::ConnectionAdapters
  module SelectWithSqlLogging
    def select(sql, *args)
      rows = nil
      elapsed = Benchmark.measure do
        rows = super(sql, *args)
      end
      msec = elapsed.real * 1000
      SqlLogging::Statistics.record_query(sql, args.first, msec, rows)
      rows
    end
  end

  class Mysql2Adapter
    prepend SelectWithSqlLogging
  end
end
