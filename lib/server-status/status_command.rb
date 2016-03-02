module ServerStatus
  class StatusCommand
    SEPARATOR = '###'


    def initialize(options)
      @options = options
      @parts   = []
    end

    def requested_options
      @requested_options ||= @options.__hash__.select { |k,v| k if v }.keys
    end

    def to_script
      if @options.os
        @parts << "lsb_release -d | cut -f2"
      end

      if @options.uptime
        @parts << "cat /proc/uptime | cut -d\" \" -f1"
      end

      if @options.load
        @parts << "cat /proc/loadavg | cut -d\" \" -f -3"
      end

      if @options.disk_usage
        @parts << "df -h | awk '/\\/$/' | sed 's/ \\+/ /g' | cut -d\" \" -f5"
      end

      if @options.inode_usage
        @parts << "df -hi | awk '/\\/$/' | sed 's/ \\+/ /g' | cut -d\" \" -f5"
      end

      if @options.memory_usage
        @parts << "free -m | sed -n 3p | sed 's/ \\+/ /g' | cut -d\" \" -f 3-"
      end

      if @options.package_updates
        @parts << "cat /var/lib/update-notifier/updates-available 2>/dev/null"
      end

      if @options.reboot_required
        @parts << "if [ -f /var/run/reboot-required ]; then echo 1 ; fi"
      end

      @parts.join("\necho '#{SEPARATOR}'\n")
    end
  end
end
