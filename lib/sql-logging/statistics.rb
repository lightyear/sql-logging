module SqlLogging
  class Statistics
    @@show_sql_backtrace = true
    @@show_top_sql_queries = :total_time
    @@top_sql_queries = 10
    @@backtrace_cleaner = nil
  
    cattr_accessor :show_sql_backtrace, :top_sql_queries
  
    def self.show_top_sql_queries
      @@show_top_sql_queries
    end
  
    def self.show_top_sql_queries=(value)
      unless [ false, :rows, :queries, :bytes, :total_time, :median_time ].include?(value)
        raise ArgumentError, "show_top_sql_queries must be one of false, :rows, :queries, :bytes, :total_time or :median_time"
      end
    
      @@show_top_sql_queries = value
    end

    @@queries = @@bytes = @@rows = 0
    @@top_queries = {}

    def self.reset_statistics!
      @@queries = @@bytes = @@rows = 0
      @@top_queries = {}
    end

    def self.backtrace_cleaner
      unless @@backtrace_cleaner
        @@backtrace_cleaner = Rails.backtrace_cleaner.dup
        @@backtrace_cleaner.add_silencer { |line| line =~ %r{sql-logging/lib} }
      end
      @@backtrace_cleaner
    end

    def self.record_query(sql, name, msec, result)
      unless name.blank? || name =~ / Columns$/ || name == :skip_logging
        bytes = 0
        if result.nil?
          ntuples = 0
        else
          result.each do |row|
            row.each do |key, value|
              bytes += key.size if key && key.respond_to?(:size)
              bytes += value.size if value && value.respond_to?(:size)
            end
          end if result.respond_to?(:each)
          ntuples = 0
          if result.respond_to?(:length)
            ntuples = result.length
          elsif result.respond_to?(:count)
            ntuples = result.count
          elsif result.respond_to?(:num_rows)
            ntuples = result.num_rows
          elsif result.respond_to?(:ntuples)
            ntuples = result.ntuples
          end
        end
      
        @@queries += 1
        @@rows += ntuples
        @@bytes += bytes

        backtrace = backtrace_cleaner.clean(caller).join("\n    ")
        unless @@show_top_sql_queries == false
          key = "#{name}:#{backtrace}"
          unless query = @@top_queries[key]
            query = LoggedQuery.new(sql, name, backtrace)
            @@top_queries[key] = query
          end
          query.log_query(ntuples || 0, bytes || 0, msec)
        end

        Rails.logger.debug "    #{ntuples} rows, #{bytes} bytes"
        Rails.logger.debug "    #{backtrace}" if @@show_sql_backtrace
      end
    end
  
    def self.log_report
      Rails.logger.debug "SQL Logging: #{@@queries} statements executed, returning #{@@bytes} bytes"
    
      unless @@show_top_sql_queries == false || @@top_queries.empty?
        Rails.logger.debug "Top #{@@top_sql_queries} SQL executions:"
        sorted_keys = @@top_queries.keys.sort_by { |k| @@top_queries[k][@@show_top_sql_queries] }.reverse
        sorted_keys.slice(0..@@top_sql_queries).each do |key|
          query = @@top_queries[key]
          Rails.logger.debug "  Executed #{query.queries} times in #{'%.1f' % query.total_time}ms " +
            "(#{'%.1f' % query.min_time}/#{'%.1f' % query.median_time}/#{'%.1f' % query.max_time}ms min/median/max), " +
            "returning #{query.rows} rows" +
            "(#{query.bytes} bytes):\n" +
            "    #{query.name}\n" +
            "    First exec was: #{query.sql}\n" +
            "    #{query.backtrace}"
        end
      end
    end
  end
end
