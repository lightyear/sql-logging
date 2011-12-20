require 'active_record/connection_adapters/mysql2_adapter'

class ActiveRecord::ConnectionAdapters::Mysql2Adapter
  def select_with_sql_logging(sql, *args)
    rows = nil
    elapsed = Benchmark.measure do
      rows = select_without_sql_logging(sql, *args)
    end
    msec = elapsed.real * 1000
    SqlLogging::Statistics.record_query(sql, args.first, msec, rows)
    rows
  end
  
  alias_method_chain :select, :sql_logging
end
