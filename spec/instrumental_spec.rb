require 'spec_helper'
require 'instrumental'

describe Instrumental do
  
  describe "configure" do
    
    # Speccing yield. http://awesomeful.net/posts/75-spec-your-yields-in-rspec
    it "should call yield" do
      # StatsCollector.should_receive(:yield).with(instance_of(StatsCollector::Configuration))
      # 
      # StatsCollector.configure do |c|
      #   c.api_key = 'foo foo'
      # end
    end
          
      
  end
  
  describe "boot" do
    
  end
  
end