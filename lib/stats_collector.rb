require 'stats_collector/agent'
require 'stats_collector/configuration'
require 'stats_collector/intervalometer'
require 'stats_collector/stats_reporter'

module StatsCollector

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
        Agent.instance.setup_and_run
      end
    end
  end

  def self.config
    @config
  end

end

include StatsCollector
