#!/usr/bin/env ruby
require "date"
require 'optparse'

opt = OptionParser.new
options = {}
opt.on('-m [month]', Integer) {|v| options[:m] = v}
opt.on('-y [year]', Integer) {|v| options[:y] = v}
opt.parse(ARGV)

month = options[:m]
year = options[:y]

today = Date.today
if month == nil
  month = today.month
end

if year == nil
  year = today.year
end

first_date = Date.new(year, month, 1)
last_date = Date.new(year, month, -1)

puts "#{month}月 #{year}".center(20)
puts "日 月 火 水 木 金 土"
print "   " * first_date.wday

first_date.upto(last_date) do |date|
  print date.strftime('%-d').rjust(2)
  if date.saturday?
    print "\n"
  end
  unless date.saturday?
    print " "
  end
end
