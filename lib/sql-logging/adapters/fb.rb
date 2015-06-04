require 'sql-logging/adapters/generic'
require 'active_record/connection_adapters/fb_adapter'

class ActiveRecord::ConnectionAdapters::FbAdapter
  include SqlLogging::Adapters::Generic
end
