require 'test_helper'

module SqlLogging
  class StatisticsTest < TestCase
    def test_default_values
      assert_equal :total_time, Statistics.show_top_sql_queries
      assert_equal true, Statistics.show_sql_backtrace
      assert_equal 10, Statistics.top_sql_queries

      assert Statistics.backtrace_cleaner.is_a?(Rails::BacktraceCleaner)
    end

    def test_setting_show_top_sql_quesries
      error = assert_raises(ArgumentError) do
        Statistics.show_top_sql_queries = 'cat'
      end
      assert_match(/show_top_sql_queries must be one of:/, error.message)
    end

    def test_backtrace_cleaner
      cleaner = Statistics.backtrace_cleaner
      assert(cleaner.class, Rails::BacktraceCleaner)
    end

    def test_data
      data = Statistics.instance_variable_get("@data")
      assert(data.class, Statistics::Data)
    end
  end
end
