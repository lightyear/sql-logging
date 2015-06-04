require 'sql-logging/adapters/generic_mysql'
require 'active_record/connection_adapters/mysql_adapter'

class ActiveRecord::ConnectionAdapters::MysqlAdapter
  include SqlLogging::Adapters::GenericMysql
end
