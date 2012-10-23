require 'active_record/connection_adapters/abstract/query_cache'

module ActiveRecord::ConnectionAdapters::QueryCache
  private

  def cache_sql_with_sql_logging(sql, &blk)
    if @query_cache.has_key?(sql)
      rows = nil
      elapsed = Benchmark.measure do
        rows = cache_sql_without_sql_logging(sql, &blk)
      end
      msec = elapsed.real * 1000
      SqlLogging::Statistics.record_query(sql, "CACHE", msec, rows)
      rows
    else
      cache_sql_without_sql_logging(sql, &blk)
    end
  end

  alias_method_chain :cache_sql, :sql_logging
end
