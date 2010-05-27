require 'spec/spec_helper'

describe ResponseCodeChecker do
  before :each do
    @counter        = mock('LogLineCounter')
    @counter_store  = mock('CounterStore', :save => nil, :last => 0)
    @notifier       = mock('Notifier', :notify => nil)
    @checker = ResponseCodeChecker.new(:response_codes => [200],
                                       :counter => @counter,
                                       :counter_store => @counter_store,
                                       :notifier      => @notifier)
  end

  describe 'perform_check' do
    it 'should save the count' do
      @counter.stub!(:count => 52)
      @counter_store.should_receive(:save).with(52)
      @checker.perform_check
    end

    describe 'when current count > threshold' do
      it 'should notify' do
        @counter_store.stub!(:last => 5)
        @counter.stub!(:count => 10)

        @checker.threshold = 4
        @notifier.should_receive(:notify).with(@checker)
        @checker.perform_check
      end
    end

    describe 'when current count == threshold' do
      it 'should notify' do
        @counter_store.stub!(:last => 5)
        @counter.stub!(:count => 10)

        @checker.threshold = 5
        @notifier.should_receive(:notify).with(@checker)
        @checker.perform_check
      end
    end

    describe 'when current count < last_count' do
      it 'should not notify' do
        @counter_store.stub!(:last => 5)
        @counter.stub!(:count => 10)

        @checker.threshold = 6
        @notifier.should_not_receive(:notify)
        @checker.perform_check
      end
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