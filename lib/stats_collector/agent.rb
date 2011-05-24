require 'singleton'

module StatsCollector
  class Agent
    include Singleton

    PORT      = 80
    
    @@queue          = []
    @@queue_mutex    = Mutex.new

    def report(type, name, value)
      # TODO: Print this to log?
      return nil unless config && config.enabled?

      hsh = { :type => type, :name => name, :value => value}
      config.logger.debug("Pushing #{ hsh.inspect } onto queue")
      @@queue_mutex.synchronize do
        @@queue.push(hsh)
      end
    end

    def setup_and_run
      @intervalometer = Intervalometer.new(config.report_interval)

      config.logger.debug("Starting agent. Reporting every #{config.report_interval} seconds")
      @thread = Thread.new do
        begin
          @intervalometer.run do
            config.logger.debug('Intervalometer run')
            new_queue_items = []
            @@queue_mutex.synchronize do
              new_queue_items = @@queue.dup
              @@queue.clear
              config.logger.debug("Queue contains #{new_queue_items.inspect}")
            end

            new_queue_items.each do |queue_item|
              send_report(queue_item)
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

    def send_report(attributes)
      type = attributes.delete(:type)
      attributes[:name] = "#{ config.name_prefix }#{ attributes[:name] }"
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