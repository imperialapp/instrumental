require 'spec_helper'
require 'stats_collector/stats_reporter'

include StatsCollector

class Agent;end

describe StatsCollector::StatsReporter do

  before(:each) do
    Agent.stub(:instance).and_return(@mock_agent_instance = mock(:agent_instance))
  end

  describe "count" do
    context "without a value" do
      it "should send a value of 1" do
        @mock_agent_instance.should_receive(:report).with(:count, 'my name', 1)

        StatsReporter.count('my name')
      end
    end

    context "with a value" do
      it "should send the passed value" do
        @mock_agent_instance.should_receive(:report).with(:count, 'my name', 23)

        StatsReporter.count('my name', 23)
      end
    end
  end

  describe "measure" do
    it "should send the passed value" do
      @mock_agent_instance.should_receive(:report).with(:measure, 'my name', 19.2)

      StatsReporter.measure('my name', 19.2)
    end
  end

  describe "timer" do
    it "should send the calculated time" do
      t = Time.now
      Time.should_receive(:now).and_return(t)
      Time.should_receive(:now).and_return(t + 1.574)

      @mock_agent_instance.should_receive(:report).with(:measure, 'my name', 1.574)

      StatsReporter.timer('my name') { 'do stuff' }
    end
  end

end