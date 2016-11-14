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
      data = Statistics.instance_variable_get('@data')
      assert(data.class, Statistics::Data)
    end

    def test_adding_a_query
      logger = MiniTest::Mock.new
      logger.expect(:debug, true) do |args|
        /0 rows, 0 bytes/.match(unwrap_array(args))
      end
      logger.expect(:debug, true) { |a| unwrap_array(a).strip.empty? }
      SqlLogging.configuration.logger = logger
      Statistics.reset_statistics!
      Statistics.record_query('SELECT 1 from some_table', 'name', 100, nil)
      assert(Statistics.data.queries, 1)
    end

    def test_log_report
      logger = MiniTest::Mock.new
      logger.expect(:debug, true) do |args|
        /0 rows, 0 bytes/.match(unwrap_array(args))
      end
      logger.expect(:debug, true) { |a| unwrap_array(a).strip.empty? }
      SqlLogging.configuration.logger = logger
      Statistics.reset_statistics!
      sql = 'SELECT 1 from some_table'
      Statistics.record_query(sql, 'name', 100, nil)
      logger.expect(:debug, true) { |a| /SQL Logging: /.match(unwrap_array(a)) }
      logger.expect(:debug, true) { |a| /Top 10/.match(unwrap_array(a)) }
      logger.expect(:debug, true,
                    ['  Executed 1 times in 100.0ms '\
                     '(100.0/100.0/100.0ms min/median/max), returning 0 ' \
                     "rows(0 bytes):\n    name\n    "\
                     "First exec was: #{sql}\n    "])
      Statistics.log_report
    end

    private

    def unwrap_array(array)
      return array unless array.is_a? Array
      array[0]
    end
  end
end
