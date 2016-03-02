require 'json'

module ServerStatus
  class Configuration
    CONFIG_PATH = File.join(Dir.home, '.server-status.json')

    attr_accessor :settings


    def initialize
      if File.exist?(CONFIG_PATH)
        @settings = JSON.parse(File.open(CONFIG_PATH).read)
      else
        @settings = {}
      end
    end

    def save
      File.open(CONFIG_PATH, 'w') do |file|
        file.write JSON.pretty_generate(@settings)
      end
    end

    def options
      # symbolize keys
      (settings['options'] || {}).each_with_object({}) do |(key, value), hash|
        hash[key.to_sym] = value
      end
    end
  end
end
