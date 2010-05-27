class ResponseCodeChecker
  attr_accessor :response_codes, :counter, :notifier, :counter_store, :threshold

  def initialize(opts = {})
    @threshold = opts[:threshold] || 1
    @counter   = opts[:counter]   || LogLineCounter.new(opts)
    @notifier  = opts[:notifier]  || SendmailNotifier.new

    @response_codes = opts[:response_codes]
    @counter_store  = opts[:counter_store] || CounterFileStore.new(file_name)
  end

  def perform_check
    if should_notify?
      notifier.notify
    end
    counter_store.save(count)
  end

  def count
    @_count ||= counter.count(regex)
  end

protected

  def should_notify?
    (count - counter_store.last) >= threshold
  end

  def regex
    / (#{response_codes.join('|')}) [0-9+]/
  end

  def file_name
    suffix = response_codes.join('_')
    "/tmp/response_count_#{suffix}"
  end

end
