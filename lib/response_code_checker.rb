class ResponseCodeChecker
  attr_accessor :response_codes, :counter, :notifier

  def initialize(opts = {})
    @threshold = opts[:threshold] || 5
    @counter   = opts[:counter]   || LogLineCounter.new(opts)

    @response_codes = opts[:response_codes]
  end

  def perform_check
    record_count
  end

  def count
    @_count ||= counter.count(regex)
  end

protected

  def regex
    / (#{response_codes.join('|')}) [0-9+]/
  end

  def record_count
    `echo #{count} > #{file_name}`
  end

  def file_name
    suffix = response_codes.join('_')
    "/tmp/response_count_#{suffix}"
  end

  # def should_notify?
  #   (count - last_count) >= threshold
  # end

  # def last_count
  #   @_last_count ||= if File.exist?(file_name)
  #                 `cat #{file_name}`.to_i
  #               else
  #                 0
  #               end
  # end
end
