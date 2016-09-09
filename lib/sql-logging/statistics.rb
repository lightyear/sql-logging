module SqlLogging
  class Statistics
    class Data
      COUNTERS = %i(queries bytes rows).freeze
      attr_accessor(*COUNTERS)
      attr_reader(:top_queries)

      def initialize
        reset!
      end

      def reset!
        COUNTERS.each { |v| instance_variable_set("@#{v}", 0) }
        @top_queries = {}
      end

      def add_query(row_counts, bytes)
        @queries += 1
        @bytes += bytes
        @rows += row_counts
      end
    end

    class << self
      extend Forwardable
      def configuration
        SqlLogging.configuration
      end

      def_delegators :configuration, :show_sql_backtrace, :top_sql_queries,
                     :show_top_sql_queries, :backtrace_cleaner,
                     :show_top_sql_queries=, :show_sql_backtrace=,
                     :top_sql_queries=

      @data = Data.new

      def_delegator :@data, :top_queries

      def reset_statistics!
        @data.reset!
      end

      def record_query(sql, name, msec, result)
        return if name.blank? || name =~ / Columns$/ || name == :skip_logging
        ntuples, bytes = tuples_and_bytes_in_result(result)

        @data.add_query(ntuple, bytes)

        backtrace = backtrace_cleaner.clean(caller).join("\n    ")
        add_query_to_top_queries(sql, name, backtrace, msec, ntuples, bytes)

        Rails.logger.debug "    #{ntuples} rows, #{bytes} bytes"
        Rails.logger.debug "    #{backtrace}" if show_sql_backtrace
      end

      private

      def add_query_to_top_queries(sql, name, backtrace, msec, ntuples, bytes)
        return unless show_top_sql_queries
        key = "#{name}:#{backtrace}"
        top_queries[key] ||= LoggedQuery.new(sql, name, backtrace)
        top_queries[key].log_query(ntuples, bytes, msec)
      end

      def tuples_and_bytes_in_result(result)
        bytes = 0
        ntuples = 0
        return [ntuples, bytes] if result.nil?
        if result.respond_to?(:each)
          result.each do |row|
            row.each do |key, value|
              bytes += key.size if key && key.respond_to?(:size)
              bytes += value.size if value && value.respond_to?(:size)
            end
          end
        end
        if result.respond_to?(:length)
          ntuples = result.length
        elsif result.respond_to?(:count)
          ntuples = result.count
        elsif result.respond_to?(:num_rows)
          ntuples = result.num_rows
        elsif result.respond_to?(:ntuples)
          ntuples = result.ntuples
        end
        [ntuples, bytes]
      end

      def log_report
        Rails.logger.debug "SQL Logging: #{@data.queries} statements executed" \
          ", returning #{@data.bytes} bytes"

        return unless have_top_queries?
        Rails.logger.debug "Top #{top_sql_queries} SQL executions:"
        sorted_keys = top_queries.keys.sort_by do |k|
          top_queries[k][show_top_sql_queries]
        end.reverse
        sorted_keys.slice(0..top_sql_queries).each do |key|
          query = top_queries[key]
          Rails.logger.debug "  Executed #{query.queries} times in "\
                             "#{'%.1f' % query.total_time}ms " \
                             "(#{'%.1f' % query.min_time}/" \
                             "#{'%.1f' % query.median_time}/" \
                             "#{'%.1f' % query.max_time}ms min/median/max), " \
                             "returning #{query.rows} rows" \
                             "(#{query.bytes} bytes):\n" \
                             "    #{query.name}\n" \
                             "    First exec was: #{query.sql}\n" \
                             "    #{query.backtrace}"
        end
      end

      def have_top_queries?
        show_top_sql_queries && !top_queries.empty?
      end
    end
  end
end
