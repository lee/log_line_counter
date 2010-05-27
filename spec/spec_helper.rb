require 'rubygems'
require 'spec'

Dir.glob("lib/*.rb").each do |filename|
  require filename
end