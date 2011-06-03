require 'spec_helper'
require 'instrumental'

class Agent;end

describe 'public instrument methods' do

  before(:each) do
    Agent.stub(:instance).and_return(@mock_agent_instance = mock(:agent_instance))
  end

  describe "count" do
    context "without a value" do
      it "should send a value of 1" do
        @mock_agent_instance.should_receive(:report).with(:count, 'my name', 1)

        Instrument.count('my name')
      end
    end

    context "with a value" do
      it "should send the passed value" do
        @mock_agent_instance.should_receive(:report).with(:count, 'my name', 23)

        Instrument.count('my name', 23)
      end
    end
  end

  describe "measure" do
    it "should send the passed value" do
      @mock_agent_instance.should_receive(:report).with(:measure, 'my name', 19.2)

      Instrument.measure('my name', 19.2)
    end
  end

  describe "timer" do
    it "should send the calculated time" do
      delta = 1.574
      Time.should_receive(:now).and_return(0)
      Time.should_receive(:now).and_return(delta)

      @mock_agent_instance.should_receive(:report).with(:measure, 'my name', delta)

      Instrument.timer('my name') { 'do stuff' }
    end
  end

end