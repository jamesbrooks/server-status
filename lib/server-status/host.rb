module ServerStatus
  class Host
    class RemoteCommandFailure < StandardError ; end

    attr_accessor :name, :status


    def initialize(config, name, host)
      @config = config
      @name   = name
      @host   = host

      @feteched_status = false
    end

    def feteched_status?
      @feteched_status
    end

    def fetch_status(status_command)
      # Fetch statuses
      raw_statuses = execute_command(status_command)

      # Hashed statuses
      raw_statuses = raw_statuses.split(ServerStatus::StatusCommand::SEPARATOR)
      raw_statuses = raw_statuses.map(&:strip)
      raw_statuses = status_command.requested_options.zip(raw_statuses).to_h

      @feteched_status = true

      @status = raw_statuses


    rescue RemoteCommandFailure => ex
      @status = { error: ex.message }
    end


  private
    def execute_command(status_command)
      stdin, stdout, stderr, wait_thread = Open3.popen3("ssh -o ConnectTimeout=10 #{@host} \"bash -s\" << EOF\n#{status_command.to_script}\nEOF")

      if wait_thread.value.success?
        stdout.read
      else
        raise RemoteCommandFailure, stderr.read
      end
    end
  end
end
