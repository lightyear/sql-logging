module SqlLogging
  module Adapters
    module GenericMysql
      def self.included(base)
        base.class_eval do
          alias_method_chain :select, :sql_logging
        end
      end

      def select_with_sql_logging(sql, *args)
        SqlLogging::Statistics.benchmark(sql, args.first) do
          select_without_sql_logging(sql, *args)
        end
      end
    end
  end
end
