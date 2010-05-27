class ResponseCodeChecker
  attr_accessor :response_codes, :counter, :notifier, :counter_store, :threshold

  def initialize(opts = {})
    @threshold = opts[:threshold] || 1
    @counter   = opts[:counter]   || LogLineCounter.new(opts)
    @notifier  = opts[:notifier]  || SendmailNotifier.new(opts[:to],
                                                          opts[:from],
                                                          opts[:subject])

    @response_codes = opts[:response_codes]
    @counter_store  = opts[:counter_store] || CounterFileStore.new(file_name)
  end

  def perform_check
    if should_notify?
      send_notification
    end
    counter_store.save(count)
  end

  def count
    @_count ||= counter.count(regex)
  end
  
  def new_hits
    count - last_count
  end

protected

  def send_notification
    notifier.notify(self)
  end

  def should_notify?
    new_hits >= threshold
  end
  
  def last_count
    @_last_count ||= counter_store.last
  end

  def regex
    / (#{response_codes.join('|')}) [0-9+]/
  end

  def file_name
    suffix = response_codes.join('_')
    "/tmp/response_count_#{suffix}"
  end

end
