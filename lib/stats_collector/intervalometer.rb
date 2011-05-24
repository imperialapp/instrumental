module StatsCollector
  class Intervalometer

    def initialize(period=60.0)
      @period = period.to_f
      @running = true
      @run_next = Time.now
    end

    def halt
      # TODO: See if it would be possible for the intervalometer to do a
      # final run before the thread exits.
      @running = false
    end

    # Runs a passed block at intervals defined by the period set during
    # initialization. Uses intervalometer to keep reasonably precise intervals.
    def run
      while @running
        if Time.now < @run_next
          sleep @run_next - Time.now
        end

        @run_next = Time.now + @period
        yield
      end
    end # run

  end
end