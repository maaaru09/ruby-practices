#!/usr/bin/env ruby

require "date"
require 'optparse'

opt = OptionParser.new
opt.on('-m') {|v| v}
opt.on('-y') {|v| v}
opt.parse!(ARGV)

month = ARGV[0].to_i
year = ARGV[1].to_i

today = Date.today
if month == 0
  month = today.month
end

if year == 0
  year = today.year
end

first_day = Date.new(year, month, 1)
last_day = Date.new(year, month, -1)
days = [*first_day..last_day]

puts "#{month}月 #{year}".center(20)
puts "日 月 火 水 木 金 土"
print "   " * first_day.wday
days.each do |day|
  print day.strftime('%-d').center(3)
  if day.saturday?
    print "\n"
  end
end
