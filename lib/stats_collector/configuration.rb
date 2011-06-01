require 'logger'

module StatsCollector
  class Configuration

    DEFAULT_REPORT_INTERVAL = 15.0

    attr_reader :host
    attr_reader :path
    attr_reader :report_interval
    attr_accessor :enabled
    attr_writer :logger
    attr_accessor :name_prefix

    def initialize
      @enabled         = defined?(::Rails.env) ? Rails.env.production? : true
      @host            = 'stats.douglasfshearer.com'
      @name_prefix     = ''
      @path            = '/in/'
      @report_interval = DEFAULT_REPORT_INTERVAL
    end

    def enabled?
      !!@enabled
    end

    def host=(val)
      @host = val

      raise(ArgumentError, "host is invalid") unless @host =~ /^[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?)?$/ix
    end

    def path=(val)
      @path = val

      raise(ArgumentError, 'path is invalid') unless @path =~ /^\/(.+\/)?$/
    end

    def report_interval=(val)
      @report_interval = val.to_f

      raise(ArgumentError, "report_interval should be greater than or equal to #{DEFAULT_REPORT_INTERVAL}") if @report_interval < DEFAULT_REPORT_INTERVAL
    end

    def api_key=(val)
      @api_key = val

      raise(ArgumentError, 'API key is invalid') unless @api_key =~ /^[a-f\d]{32}$/
    end

    def api_key
      @api_key || raise(ArgumentError, 'API key must be set in configuration')
    end

    def logger
      # The Rails logger is not available in an initializer, so we have to look for on-demand.
      @logger ||= defined?(::Rails.logger) ? Rails.logger : Logger.new(STDOUT)
      @logger
    end

  end
end