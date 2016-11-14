require 'rails'
require 'active_record'
require 'action_view'
require 'singleton'

require 'sql-logging/controller_runtime'
require 'sql-logging/configuration'
require 'sql-logging/helper'
require 'sql-logging/logged_query'
require 'sql-logging/statistics'
require 'sql-logging/railtie'
require 'sql-logging/version'

module SqlLogging
  def self.configuration
    @configuration ||= Configuration.new
  end
end
