require 'spec/spec_helper'

describe CounterFileStore do
  before :each do
    @store = CounterFileStore.new('junk')
  end

  describe 'save' do
    it 'should use *nix commands to save the count' do
      @store.should_receive(:'`').with(/echo 52 > junk/)
      @store.save(52)
    end
  end

  describe 'last' do
    describe 'when the file exists' do
      before :each do
        File.stub!(:exists? => true)
      end

      it 'should use *nix commands to read the contents' do
        @store.should_receive(:'`').with(/cat junk/).and_return('0\n')
        @store.last
      end

      it 'should return an integer' do
        @store.stub!(:'`' => '52\n')
        @store.last.should == 52
      end
    end

    describe 'when the file does not exist' do
      it 'should be 0' do
        File.stub!(:exists? => false)
        @store.last.should == 0
      end
    end
  end
end