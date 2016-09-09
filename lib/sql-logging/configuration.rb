# frozen_string_literal: true
module SqlLogging
  class Configuration
    DEFAULTS = {
      show_sql_backtrace: true,
      show_top_sql_queries: :total_time,
      top_sql_queries: 10,
      backtrace_cleaner: nil
    }.freeze

    attr_writer(*DEFAULTS.keys - [:show_top_sql_queries=])
    attr_reader(*DEFAULTS.keys - %i(logger backtrace_cleaner))

    def initialize
      DEFAULTS.each do |k, v|
        send("#{k}=", v)
      end
    end

    def show_top_sql_queries=(value)
      validate_allowed([false, :rows, :queries, :bytes, :total_time,
                        :median_time], value)
      @show_top_sql_queries = value
    end

    def backtrace_cleaner
      @backtrace_cleaner ||= initialize_cleaner
    end

    private

    def initialize_cleaner
      Rails.backtrace_cleaner.dup.tap do |cleaner|
        cleaner.add_silencer { |line| line =~ %r{sql-logging/lib} }
      end
    end

    def validate_allowed(allowed_values, value)
      return if allowed_values.include?(value)
      method_match = /`(.*)='/.match(caller(1, 1)[0])
      method_name = method_match ? method_match[1] : 'Argument'
      raise ArgumentError, "#{method_name} must be one of: " \
                           "#{allowed_values.map(&:inspect).join(', ')}"
    end
  end
end
