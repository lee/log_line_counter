class LogLineCounter

  def self.defaults
    {:log_file => 'log.access.log'}
  end

  def initialize(opts = {})
    opts = self.class.defaults.merge(opts)
    @log_file = opts[:log_file]
  end

  def count(regex)
    line_count = `#{cat_cmd} #{@log_file} | egrep "#{regex}" | wc -l`
    line_count.to_i
  end

protected

  def cat_cmd
    if @log_file.index(/\.gz$/)
      'zcat'
    else
      'cat'
    end
  end
end
