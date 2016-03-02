module ServerStatus
  module Commands
    class Add < BaseCommand
      def initialize(config, host, name=nil)
        super(config)

        @host = host
        @name = name || host
      end

      def perform
        settings['hosts'] ||= {}

        # Check to see if we're already tracking
        settings['hosts'].each do |name, host|
          if name == @name
            puts "#{name} already exists"
            exit(1)
          end
        end

        settings['hosts'][@name] = @host
        config.save

        puts "Added #{@name}"
      end
    end
  end
end
