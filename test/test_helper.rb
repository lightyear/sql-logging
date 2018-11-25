require File.dirname(__FILE__) + '/../lib/sql-logging'

require 'minitest/autorun'

MiniTest::Test = MiniTest::Unit::TestCase unless defined?(MiniTest::Test)
module SqlLogging
  class TestCase < MiniTest::Test

  end
end
