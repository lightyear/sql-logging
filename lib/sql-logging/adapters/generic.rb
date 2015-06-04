module SqlLogging
  module Adapters
    module Generic
      def self.included(base)
        base.class_eval do
          alias_method_chain :execute, :sql_logging

          if method_defined? :exec_query
            alias_method_chain :exec_query, :sql_logging
          end
        end
      end

      def execute_with_sql_logging(sql, name = nil)
        SqlLogging::Statistics.benchmark(sql, name) do
          execute_without_sql_logging(sql, name)
        end
      end

      def exec_query_with_sql_logging(sql, name = nil, binds = [])
        SqlLogging::Statistics.benchmark(sql, name) do
          exec_query_without_sql_logging(sql, name, binds)
        end
      end
    end
  end
end
