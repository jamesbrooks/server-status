module ServerStatus
  class Report
    COLUMN_SPACING = 5


    def initialize(config, options, host_set)
      @config   = config
      @options  = options
      @host_set = host_set
    end

    def generate_table
      str = "\n"

      # Gather failures
      failed_columns = if (failed_hosts = @host_set.hosts.reject(&:feteched_status?)).any?
        failed_hosts.map do |host|
          { name: host.name, error: host.status[:error].strip }
        end
      end


      columns = [ :host ] + @host_set.hosts.detect(&:feteched_status?).status.keys

      # Process status values
      statuses = @host_set.hosts.select(&:feteched_status?).map do |host|
        host.status.each_with_object({ host: host.name }) do |(k, v), hash|
          hash[k] = send("format_#{k}", v)
        end
      end

      # Determine column widths
      column_widths = columns.each_with_object({}) do |col, hash|
        sizes  = statuses.map { |s| s[col].uncolorize.size }
        sizes << col.to_s.size

        hash[col] = sizes.max
      end


      # Render headings
      column_widths.each do |col, col_width|
        str << col.to_s.upcase.colorize(:blue)
        str << ' ' * (COLUMN_SPACING + col_width - col.size)
      end

      str << "\n"


      # Render table
      statuses.sort { |x,y| x[:host] <=> y[:host] }.each do |status|
        column_widths.each do |col, col_width|
          str << status[col]
          str << ' ' * (COLUMN_SPACING + col_width - status[col].uncolorize.size)
        end

        str << "\n"
      end

      # Display failures at the end
      if failed_columns
        str << "\nFAILED HOSTS".colorize(:blue)
        str << "\n"
        failed_columns.each do |host|
          str << host[:name]
          str << ' ' * (COLUMN_SPACING + column_widths[:host] - host[:name].uncolorize.size)
          str << host[:error].colorize(:red)
          str << "\n"
        end
      end

      str << "\n"
      str
    end


  private
    # Formatters
    def format_os(val)
      val
    end

    def format_uptime(val)
      "#{val.to_i / 86400} days"
    end

    def format_load(val)
      val
    end

    def format_disk_usage(val)
      format_percentage(val)
    end

    def format_inode_usage(val)
      format_percentage(val)
    end

    def format_memory_usage(val)
      used, available = val.split(' ').map(&:to_f)
      format_percentage(used / (used + available))
    end

    def format_clock_drift(val)
      if val == ""
        return "??? ms".colorize(:red)
      end

      # Drift in milliseconds
      drift = (val.to_f * 1000).round

      color = if drift.abs < 2000
        :normal
      elsif drift.abs < 30_000
        :yellow
      else
        :red
      end

      "#{drift} ms".colorize(color)
    end

    def format_package_updates(val)
      str = ''

      if val =~ /(\d+) packages can be updated/
        str << $1 if $1.to_i != 0
      end

      if val =~ /(\d+) (updates are|update is a) security update(s)?/
        str << " (#{$1} security)".colorize(:red) if $1.to_i != 0
      end

      str
    end

    def format_reboot_required(val)
      if val.to_i == 1
        'YES'.colorize(:yellow)
      else
        'NO'
      end
    end

    def format_percentage(val)
      if val.is_a?(String)
        # Convert from string % to float
        val = val.to_f / 100
      end

      color = if val > 0.85
        :red
      elsif val > 0.7
        :yellow
      else
        :normal
      end

      "#{(val * 100).round(0)}%".colorize(color)
    end
  end
end
