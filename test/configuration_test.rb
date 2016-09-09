require 'test_helper'

module SqlLogging
  class ConfigurationTest < TestCase
    def test_configuration_defaults
      config = Configuration.new
      assert_equal(config.logger, Rails.logger)
      assert_equal(config.top_sql_queries, 10)
    end

    def test_show_top_sql_queries_allowed_values
      allowed_values = [false, :rows, :queries, :bytes, :total_time,
                        :median_time]
      config = Configuration.new
      allowed_values.each do |v|
        config.show_top_sql_queries = v
        assert_equal(config.show_top_sql_queries, v)
      end
    end

    def test_show_top_sql_queries_raises_error_with_bad_value
      config = Configuration.new
      error = assert_raises(ArgumentError) do
        config.show_top_sql_queries = 'cat'
      end
      assert_match(/show_top_sql_queries must be one of:/, error.message)
    end

    def test_default_backtrace_cleaner_filters_this_gem
      backtrace_cleaner = Configuration.new.backtrace_cleaner
      assert_equal(
        backtrace_cleaner.clean(['/lib/blah', '/sql-logging/lib/blah']),
        ['lib/blah']
      )
    end
  end
end
