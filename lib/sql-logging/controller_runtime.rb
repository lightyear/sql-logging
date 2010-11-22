module SqlLogging
  module ControllerRuntime
    extend ActiveSupport::Concern

  protected

    module ClassMethods
      def log_process_action(payload)
        SqlLogging::Statistics.log_report
        super
      end
    end
  end
end
