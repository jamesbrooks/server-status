require 'thread'

module ServerStatus
  class HostSet
    attr_accessor :config, :options, :hosts


    def initialize(config, options, hosts)
      @config  = config
      @options = options
      @hosts   = hosts.map { |host, name| Host.new(config, host, name) }
    end

    def fetch_statuses
      progress_bar = TTY::ProgressBar.new("Querying hosts [:bar]", total: @hosts.size, clear: true, hide_cursor: true)
      semaphore = Mutex.new
      completed_hosts = 0

      threads = @hosts.map do |host|
        Thread.new do
          host.fetch_status(status_command)
          semaphore.synchronize { progress_bar.advance }
        end
      end

      threads.each(&:join)
    end


  private
    def status_command
      @status_command ||= ServerStatus::StatusCommand.new(@options)
    end
  end
end
