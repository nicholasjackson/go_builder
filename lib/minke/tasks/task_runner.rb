module Minke
  module Tasks
    class TaskRunner

      def initialize args
        @ruby_helper       = args[:ruby_helper]
        @copy_helper       = args[:copy_helper]
        @service_discovery = args[:service_discovery]
        @logger            = args[:logger_helper]
      end

      ##
      # execute the defined steps in the given Minke::Config::TaskRunSettings
      def run_steps steps
        execute_ruby_tasks steps.tasks unless steps.tasks == nil
        copy_assets steps.copy unless steps.copy == nil
      end

      private
      ##
      # execute an array of rake tasks
      def execute_ruby_tasks tasks
        tasks.each { |t| 
          @logger.debug "Executing task: #{t}"
          @ruby_helper.invoke_task(t, @logger)
        }
      end

      ##
      # copys the assets defined in the step
      def copy_assets assets
        assets.each do |a| 
          @logger.debug "Copy #{a.from} To #{a.to}"
          @copy_helper.copy_assets a.from, a.to
        end
      end

    end
  end
end
