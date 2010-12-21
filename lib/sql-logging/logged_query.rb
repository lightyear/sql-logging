class LoggedQuery
  attr_accessor :sql, :name, :backtrace, :queries, :rows, :bytes
  
  def initialize(sql, name, backtrace)
    @sql = sql
    @name = name
    @backtrace = backtrace
    @queries = 0
    @rows = 0
    @bytes = 0
    @times = []
  end
  
  def log_query(rows, bytes, time)
    @queries += 1
    @rows += rows
    @bytes += bytes
    @times << time
  end
  
  def [](key)
    case key.to_sym
    when :sql
      @sql
    when :name
      @name
    when :backtrace
      @backtrace
    when :queries
      @queries
    when :rows
      @rows
    when :bytes
      @bytes
    when :median_time
      median_time
    when :total_time
      total_time
    else nil
    end
  end
  
  def median_time
    total_time / @times.length
  end
  
  def min_time
    @times.min
  end
  
  def max_time
    @times.max
  end
  
  def total_time
    @times.inject(0) { |sum, time| sum += time }
  end
end
