require 'spec_helper'
require "flapjack-diner/argument_validator"

describe Flapjack::ArgumentValidator do

  context 'required' do

    let(:query) do
      {:entity => 'myservice', :check => 'HOST'}
    end

    subject { Flapjack::ArgumentValidator.new(query) }

    it 'does not raise an exception when query entity is valid' do
      lambda { subject.validate(:query => :entity, :as => :required) }.should_not raise_exception(ArgumentError)
    end

    it 'raises ArgumentError when query entity is invalid' do
      query[:entity] = nil
      lambda { subject.validate(:query => :entity, :as => :required) }.should raise_exception(ArgumentError)
    end

    it 'handles arrays as query values valid' do
      lambda { subject.validate(:query => [:entity, :check], :as => :required) }.should_not raise_exception(ArgumentError)
    end

    it 'handles arrays as query values invalid' do
      query[:check] = nil
      lambda { subject.validate(:query => [:entity, :check], :as => :required) }.should raise_exception(ArgumentError)
    end
  end

  context 'time' do

    let(:query) do
      {:start_time => Time.now, :duration => 10}
    end

    subject { Flapjack::ArgumentValidator.new(query) }

    it 'does not raise an exception when query start_time is valid' do
      lambda { subject.validate(:query => :start_time, :as => :time) }.should_not raise_exception(ArgumentError)
    end

    it 'raises an exception when query start_time is invalid' do
      query[:start_time] = 1234
      lambda { subject.validate(:query => :start_time, :as => :time) }.should raise_exception(ArgumentError)
    end

    it 'handles arrays as query values valid' do
      query[:end_time] = Time.now
      lambda { subject.validate(:query => [:start_time, :end_time], :as => :time) }.should_not raise_exception(ArgumentError)
    end

    it 'handles arrays as query values invalid' do
      query[:end_time] = 3904
      lambda { subject.validate(:query => [:start_time, :end_time], :as => :time) }.should raise_exception(ArgumentError)
    end

    it 'handles dates as query values' do
      query[:end_time] = Date.today
      lambda { subject.validate(:query => :end_time, :as => :time) }.should_not raise_exception(ArgumentError)
    end

    it 'handles ISO 8601 strings as query values' do
      query[:end_time] = Time.now.iso8601
      lambda { subject.validate(:query => :end_time, :as => :time) }.should_not raise_exception(ArgumentError)
    end

    it 'raises an exception when invalid time strings are provided' do
      query[:end_time] = '2011-08-01T00:00'
      lambda { subject.validate(:query => :end_time, :as => :time) }.should raise_exception(ArgumentError)
    end
  end

  context 'integer via method missing' do

    let(:query) do
      {:start_time => Time.now, :duration => 10}
    end

    subject { Flapjack::ArgumentValidator.new(query) }

    it 'does not raise an exception when query duration is valid' do
      lambda { subject.validate(:query => :duration, :as => :integer) }.should_not raise_exception(ArgumentError)
    end

    it 'raises an exception when query duration is invalid' do
      query[:duration] = '23'
      lambda { subject.validate(:query => :duration, :as => :integer) }.should raise_exception(ArgumentError)
    end
  end

  context 'multiple validations' do

    let(:query) do
      {:start_time => Time.now, :duration => 10}
    end

    subject { Flapjack::ArgumentValidator.new(query) }

    it 'does not raise an exception when query start_time is valid' do
      lambda { subject.validate(:query => :start_time, :as => [:time, :required]) }.should_not raise_exception(ArgumentError)
    end

    it 'raises an exception when query start_time is invalid' do
      query[:start_time] = nil
      lambda { subject.validate(:query => :start_time, :as => [:time, :required]) }.should raise_exception(ArgumentError)
    end
  end
end
