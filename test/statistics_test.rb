require 'test_helper'

module SqlLogging
  class StatisticsTest < TestCase
    def test_default_values
      assert_equal :total_time, Statistics.show_top_sql_queries
      assert_equal true, Statistics.show_sql_backtrace
      assert_equal 10, Statistics.top_sql_queries

      assert Statistics.backtrace_cleaner.is_a?(Rails::BacktraceCleaner)
    end
  end
end
