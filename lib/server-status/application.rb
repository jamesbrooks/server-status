module ServerStatus
  class Application
    include Commander::Methods

    attr_accessor :configuration


    def initialize
      @config = ServerStatus::Configuration.new
    end

    def run
      never_trace!

      program :name, 'Server Status'
      program :version, ServerStatus::VERSION
      program :description, 'Fast remote host statuses'

      default_command :run

      command :run do |c|
        c.description = 'Fetch statuses of all tracked hosts (default)'

        c.option '--[no-]os'
        c.option '--[no-]uptime'
        c.option '--[no-]load'
        c.option '--[no-]disk-usage'
        c.option '--[no-]inode-usage'
        c.option '--[no-]memory-usage'
        c.option '--[no-]clock-drift'
        c.option '--[no-]package-updates'
        c.option '--[no-]reboot-required'

        c.action do |args, options|
          options.default({
            os:              false,
            uptime:          true,
            load:            true,
            disk:            true,
            inode:           true,
            memory:          true,
            clock_drift:     true,
            pkg_updates:     true,
            reboot_required: false
          }.merge(@config.options))

          ServerStatus::Commands::Run.new(@config, options).perform
        end
      end

      command :list do |c|
        c.description = 'List all currently tracked hosts'

        c.action do
          ServerStatus::Commands::List.new(@config).perform
        end
      end

      command :add do |c|
        c.syntax = 'add <host> [name]'
        c.description = 'Add a remote host'

        c.action do |args, options|
          if args.size < 1 || args.size > 2
            puts "requires either 1 or 2 arguments\n\n\tadd <host> [friendly-name]\n\n"
            exit(1)
          end

          ServerStatus::Commands::Add.new(@config, *args).perform
        end
      end

      command :remove do |c|
        c.syntax = 'remove <name>'
        c.description = 'Remove a remote host'

        c.action do |args, options|
          unless args.size == 1
            puts "requires 1 argument\n\n\tremove <name>\n\n"
            exit(1)
          end

          ServerStatus::Commands::Remove.new(@config, *args).perform
        end
      end

      run!
    end
  end
end
