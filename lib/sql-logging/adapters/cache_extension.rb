require 'active_record/connection_adapters/abstract/query_cache'

module ActiveRecord::ConnectionAdapters::QueryCache
  module CacheSQLWithSqlLogging
    def cache_sql(sql, binds, &blk)
      if @query_cache.has_key?(sql)
        rows = nil
        elapsed = Benchmark.measure do
          rows = super(sql, binds, &blk)
        end
        msec = elapsed.real * 1000
        SqlLogging::Statistics.record_query(sql, "CACHE", msec, rows)
        rows
      else
        super(sql, binds, &blk)
      end
    end
  end

  private

  def self.included(klass)
    klass.prepend CacheSQLWithSqlLogging
  end
end
