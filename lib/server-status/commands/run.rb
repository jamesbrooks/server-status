module ServerStatus
  module Commands
    class Run < BaseCommand
      def initialize(config, options)
        super(config)

        @options = options
      end

      def perform
        unless settings['hosts']
          puts "No hosts tracked. To add hosts: server-status add <host> [name]"
          exit(1)
        end

        host_set = ServerStatus::HostSet.new(config, @options, settings['hosts'])
        host_set.fetch_statuses

        report = ServerStatus::Report.new(config, @options, host_set)
        puts report.generate_table
      end
    end
  end
end
