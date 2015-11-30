require 'minitest/autorun'

require File.dirname(__FILE__) + '/../lib/sql-logging'

MiniTest::Test = MiniTest::Unit::TestCase unless defined?(MiniTest::Test)
module SqlLogging
  class TestCase < MiniTest::Test

  end
end
