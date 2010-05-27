require 'spec/spec_helper'

describe ResponseCodeChecker do
  before :each do
    @counter = mock('LogLineCounter')
    @checker = ResponseCodeChecker.new(:response_codes => [200],
                                              :counter => @counter)
  end

  describe 'perform_check' do
    it 'should save the count to a file' do
      @counter.stub!(:count => 52)
      @checker.should_receive(:'`').with(/echo 52/)
      @checker.perform_check
    end

    it 'should save to a file with the response_codes in the filename' do
      @counter.stub!(:count => 52)
      @checker.response_codes = [200,302]
      @checker.should_receive(:'`').with(/200_302/)
      @checker.perform_check
    end
  end

  describe 'count' do
    it 'should delegate to the counter' do
      @counter.stub!(:count => :delegated)
      @checker.count.should == :delegated
    end

    it 'should pass the regex to counter' do
      @counter.should_receive(:count).with(/ (200) [0-9+]/)
      @checker.count
    end
  end
end