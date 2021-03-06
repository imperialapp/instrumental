require 'instrumental/agent'
require 'instrumental/configuration'
require 'instrumental/intervalometer'
require 'instrumental/railtie' if defined?(::Rails)


module Instrumental

  @config = Configuration.new

  def self.configure
    yield @config
  end

  def self.boot!
    if @config.enabled?

      if defined?(PhusionPassenger)
        PhusionPassenger.on_event(:starting_worker_process) do
          @config.logger.debug('Starting a new worker process')
          Agent.instance.setup_and_run
        end

        PhusionPassenger.on_event(:stopping_worker_process) do
          @config.logger.debug('Killing worker process')
          Agent.instance.stop
        end

      else
        @config.logger.debug('Starting a new worker process')
        Agent.instance.setup_and_run
      end
    end
  end

  def self.config
    @config
  end

  def self.count(name, value=1)
    Agent.instance.report(:count, name, value)
  end

  def self.measure(name, value)
    Agent.instance.report(:measure, name, value)
  end

  def self.timer(name)
    start_time = Time.now
    yield
    self.measure(name, (Time.now - start_time) * 1000) # milliseconds
  end

  def self.milestone(name)
    Agent.instance.milestone(name)
  end

end
