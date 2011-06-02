module Instrumental
  module Instrument

    def self.count(name, value=1)
      Agent.instance.report(:count, name, value)
    end

    def self.measure(name, value)
      Agent.instance.report(:measure, name, value)
    end

    def self.timer(name)
      start_time = Time.now
      yield
      self.measure(name, Time.now - start_time)
    end

  end
end