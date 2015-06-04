require 'active_record/connection_adapters/abstract/query_cache'

module ActiveRecord::ConnectionAdapters::QueryCache
  private

  def cache_sql_with_sql_logging(sql, binds, &blk)
    if @query_cache.has_key?(sql)
      SqlLogging::Statistics.benchmark(sql, 'CACHE') do
        cache_sql_without_sql_logging(sql, binds, &blk)
      end
    else
      cache_sql_without_sql_logging(sql, binds, &blk)
    end
  end

  alias_method_chain :cache_sql, :sql_logging
end
