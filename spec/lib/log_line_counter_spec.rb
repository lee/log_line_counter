require 'spec/spec_helper'

describe LogLineCounter do
  describe 'cat_cmd' do
    it 'should be cat for non-gzipped files' do
      counter = LogLineCounter.new(:log_file => 'file.log')
      counter.send(:cat_cmd).should == 'cat'
    end

    it 'should be zcat for gzipped files' do
      counter = LogLineCounter.new(:log_file => 'file.gz')
      counter.send(:cat_cmd).should == 'zcat'
    end
  end

  describe 'count' do
    before :each do
      @counter = LogLineCounter.new(:log_file => 'file.log')
    end

    it 'should return as an integer' do
      @counter.stub!(:'`' => '42\n')
      @counter.count(/junk/).should == 42
    end

    it 'should leverage os commands to get the count' do
      @counter.should_receive(:'`').with(/cat file.log.*\|.*egrep.*junk.*\|.*wc -l/)
      @counter.count(/junk/)
    end
  end
end