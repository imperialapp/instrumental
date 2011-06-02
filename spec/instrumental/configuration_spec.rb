require 'spec_helper'
require 'instrumental/configuration'

include Instrumental

class Rails;end # Used for testing the logger.

describe Instrumental::Configuration do

  before(:each) do
    @config = Configuration.new
  end

  describe "in the default state" do
    it "should raise an argument error for the missing API key" do
      lambda { @config.api_key }.should raise_error(ArgumentError, 'API key must be set in configuration')
    end

    it "should have a host" do
      @config.host.should == 'stats.douglasfshearer.com'
    end

    it "should have a path" do
      @config.path.should == '/in/'
    end

    it "should have a report interval" do
      @config.report_interval.should == 15.0
    end

    it "should have a logger" do
      @config.logger.should be_a(Logger)
    end

    it "should have enabled set to true" do
      @config.logger.should be_true
    end

    it "should have an empty name prefix" do
      @config.name_prefix.should be_empty
    end
  end

  describe "where Rails is defined" do
    context "production environment" do
      before(:each) do
        Rails.stub(:logger).and_return(@mock_logger = mock(:logger))
        Rails.stub(:env).and_return(mock(:environment, :production? => true))
        @rails_config = Configuration.new
      end

      it "should be the mock logger" do
        @rails_config.logger.should == @mock_logger
      end

      it "should have enabled as true" do
        @rails_config.enabled.should be_true
      end
    end

    context "non-production environment" do
      before(:each) do
        Rails.stub(:env).and_return(mock(:environment, :production? => false))
        @rails_config = Configuration.new
      end

      it "should have enabled as false" do
        @rails_config.enabled.should be_false
      end
    end
  end

  describe "Setting the API key" do
    context "with a valid key" do
      before(:each) do
        @config.api_key = '01e694159b73a5f3784bbe9d63412b8d'
      end

      it "should not raise an error" do
        lambda { @config.api_key }.should_not raise_error
      end

      it "should have an API key" do
        @config.api_key.should == '01e694159b73a5f3784bbe9d63412b8d'
      end
    end

    %w{cheese 123 01e694159b73a5f3784bbe9d63412b8 01e694159b73a5f3784bbe9d63412b8D}.each do |invalid_key|
      context "with invalid key, #{invalid_key}," do
        it "should raise an argument error" do
          lambda { @config.api_key = invalid_key }.should raise_error(ArgumentError, 'API key is invalid')
        end
      end
    end
  end

  describe "Setting the report_interval" do
    context "with a valid value" do
      it "should not raise an error" do
        lambda { @config.report_interval = 20.1 }.should_not raise_error
      end

      it "should have the report_interval set" do
        @config.report_interval = 20.1
        @config.report_interval.should == 20.1
      end
    end
  end

  describe "Setting the host" do
    %w{stats.douglasfshearer.com foo.bar.com foo.bar.rar.me}.each do |valid_host|
      context "with a valid host, #{valid_host}" do
        it "should not raise an error" do
          lambda { @config.host = valid_host }.should_not raise_error
        end

        it "should have the host set" do
          @config.host = valid_host
          @config.host.should == valid_host
        end
      end
    end

    %w{stats.douglasfshearer.com/ http://stats.douglasfshearer.com mince}.each do |invalid_host|
      context "with invalid host, #{invalid_host}," do
        it "should raise an argument error" do
          lambda { @config.host = invalid_host }.should raise_error(ArgumentError, 'host is invalid')
        end
      end
    end

    context "with a blank host" do
      it "should raise an argument error" do
        lambda { @config.host = '' }.should raise_error(ArgumentError, 'host is invalid')
      end
    end
  end

  describe "Setting the path" do
    %w{/ /foo/ /bar/rar/ /23/}.each do |valid_path|
      context "with a valid path, #{valid_path}" do
        it "should not raise an error" do
          lambda { @config.path = valid_path }.should_not raise_error
        end

        it "should have the path set" do
          @config.path = valid_path
          @config.path.should == valid_path
        end
      end
    end

    %w{// bar/ /bar bar}.each do |invalid_path|
      context "with invalid path, #{invalid_path}," do
        it "should raise an argument error" do
          lambda { @config.path = invalid_path }.should raise_error(ArgumentError, 'path is invalid')
        end
      end
    end

    context "with a blank path" do
      it "should raise an argument error" do
        lambda { @config.path = '' }.should raise_error(ArgumentError, 'path is invalid')
      end
    end
  end

  describe "setting the logger" do
    it "should have the logger set" do
      @config.logger = 'foo'
      @config.logger.should == 'foo'
    end
  end

  describe "setting enabled" do
    before(:each) do
      @config.enabled = 'non nil value'
    end

    it "should have the enabled status set" do
      @config.enabled.should == 'non nil value'
    end
  end

  describe "enabled?" do
    it "should be false for nil" do
      @config.enabled = nil
      @config.should_not be_enabled
    end

    it "should be false for false" do
      @config.enabled = false
      @config.should_not be_enabled
    end

    it "should be true for true" do
      @config.enabled = true
      @config.should be_enabled
    end

    it "should be true for other values" do
      @config.enabled = 'non nil value'
      @config.should be_enabled
    end
  end

  describe "setting the name_prefix" do
    it "should have the name_prefix set" do
      @config.name_prefix = 'my prefix'
      @config.name_prefix.should == 'my prefix'
    end
  end

end