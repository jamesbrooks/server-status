module ServerStatus
  module Commands
    class Remove < BaseCommand
      def initialize(config, name)
        super(config)
        @name = name
      end

      def perform
        if settings['hosts'] && settings['hosts'][@name]
          settings['hosts'].delete(@name)
          config.save

          puts "Removed #{@name}"

          return
        end

        puts "#{@name} does not exist"
        exit(1)
      end
    end
  end
end
