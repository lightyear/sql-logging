require 'sql-logging/adapters/generic_mysql'
require 'active_record/connection_adapters/pedant_mysql2_adapter'

class ActiveRecord::ConnectionAdapters::Mysql2Adapter
  include SqlLogging::Adapters::GenericMysql
end
