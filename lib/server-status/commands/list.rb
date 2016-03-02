module ServerStatus
  module Commands
    class List < BaseCommand
      def perform
        if settings['hosts'].any?
          longest_name = settings['hosts'].map { |n, h| n.size }.max

          settings['hosts'].each do |name, host|
            puts "#{name.ljust(longest_name)}  #{host}"
          end
        end
      end
    end
  end
end
