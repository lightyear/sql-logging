require 'sql-logging/statistics'
require 'rails'
require 'active_record'

module SqlLogging
  class Railtie < Rails::Railtie
    initializer 'sql_logging.load_adapter_extensions' do
      ActiveSupport.on_load(:active_record, :after => 'active_record.initialize_database') do
        adapter = ActiveRecord::Base.configurations[Rails.env]['adapter']
        require "sql-logging/adapters/cache_extension"
        begin
          require "sql-logging/adapters/#{adapter}"
        rescue LoadError => e
          Rails.logger.warn "SQL Logging extensions are not available for #{adapter}; functionality will be limited"
        end
      end
    end
    
    initializer 'sql_logging.reset_statistics' do
      ActiveSupport.on_load(:active_record) do
        ActionDispatch::Callbacks.before do
          SqlLogging::Statistics.reset_statistics!
        end
      end
    end

    initializer 'sql_logging.log_runtime' do
      require "sql-logging/controller_runtime"
      ActiveSupport.on_load(:action_controller) do
        include SqlLogging::ControllerRuntime
      end
    end
  end
end
