module ServerStatus
  class StatusCommand
    SEPARATOR = '###'


    def initialize(options)
      @options = options
    end

    def requested_options
      @requested_options ||= @options.__hash__.select { |k,v| k if v }.keys
    end

    def to_script
      parts = []

      if @options.os
        parts << "lsb_release -d | cut -f2"
      end

      if @options.uptime
        parts << "cat /proc/uptime | cut -d\" \" -f1"
      end

      if @options.load
        parts << "cat /proc/loadavg | cut -d\" \" -f -3"
      end

      if @options.disk
        parts << "df -h | awk '/\\/$/' | sed 's/ \\+/ /g' | cut -d\" \" -f5"
      end

      if @options.inode
        parts << "df -hi | awk '/\\/$/' | sed 's/ \\+/ /g' | cut -d\" \" -f5"
      end

      if @options.memory
        parts << "cat /proc/meminfo | grep -P '^(MemTotal|MemFree|Cached|Buffers):'"
      end

      if @options.clock_drift
        parts << "ntpdate -q pool.ntp.org | head -1 | cut -d \" \" -f 6 | sed \"s/.$//\""
      end

      if @options.pkg_updates
        parts << "cat /etc/motd || cat /var/run/motd.dynamic || true"
      end

      if @options.reboot_required
        parts << "if [ -f /var/run/reboot-required ]; then echo 1 ; fi"
      end

      parts.join("\necho '#{SEPARATOR}'\n")
    end
  end
end
