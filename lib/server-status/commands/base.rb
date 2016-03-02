module ServerStatus
  module Commands
    class BaseCommand
      attr_accessor :config


      def initialize(config)
        @config = config
      end

      def settings
        config.settings
      end
    end
  end
end
