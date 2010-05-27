class CounterFileStore
  attr_reader :file_name

  def initialize(file_name)
    @file_name = file_name
  end

  def save(count)
    `echo #{count} > #{file_name}`
  end

  def last
    if File.exists?(file_name)
      `cat #{file_name}`.to_i
    else
      0
    end
  end
end