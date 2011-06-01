require 'singleton'
require 'net/http'

module StatsCollector
  class Agent
    include Singleton

    PORT      = 80

    @@queue          = { :count => {}, :measure => {} }
    @@queue_mutex    = Mutex.new

    def report(type, name, value)
      # TODO: Print this to log?
      return nil unless config && config.enabled?

      type = type.to_sym
      @@queue_mutex.synchronize do
        if type == :count
          @@queue[:count][name] ||= 0
          @@queue[:count][name] += value
        else
          @@queue[:measure][name] ||= []
          @@queue[:measure][name] << value
        end
      end
    end

    def setup_and_run
      @intervalometer = Intervalometer.new(config.report_interval)

      config.logger.debug("Starting agent. Reporting every #{config.report_interval} seconds")
      @thread = Thread.new do
        begin
          @intervalometer.run do
            config.logger.debug('Intervalometer run')
            new_queue_items = {}
            @@queue_mutex.synchronize do
              new_queue_items = @@queue.dup
              @@queue[:count] = {}
              @@queue[:measure] = {}
              config.logger.debug("Queue contains #{new_queue_items.inspect}")
            end

            new_queue_items[:count].each do |name, value|
              send_report(:count, name, value)
            end

            new_queue_items[:measure].each do |name, values|
              send_report(:measure, name, values.join(','))
            end
          end
        rescue => e
          config.logger.error e
          config.logger.error e.backtrace.join("\n")
        end
      end
    end

    def stop
      # If the app crashes, Passenger calls halt as it winds-down the process.
      # Only call halt if intervalometer exists.
      @intervalometer && @intervalometer.halt
    end

    protected

    def config
      StatsCollector.config
    end

    def send_report(type, name, value)
      if type == :measure
        attributes = { :values => value }
      else
        attributes = { :value => value }
      end
      attributes[:name] = CGI.escape("#{ config.name_prefix }#{ name }")
      attributes[:api_key] = config.api_key

      attributes_string = attributes.to_a.map{ |a| a.join('=') }.join('&')

      path = "#{ config.path }#{ type }?#{ attributes_string }"
      config.logger.debug("Calling #{ path }")

      response = Net::HTTP.get_response(config.host, path, PORT)

      unless response.is_a?(Net::HTTPSuccess)
        config.logger.error "[StatsReporter] Unexpected response from server (#{ response.code }): #{ response.message }"
      end
    end

  end
end