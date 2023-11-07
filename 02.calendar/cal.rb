#!/usr/bin/env ruby
require "date"
require 'optparse'

opt = OptionParser.new
options = {}
opt.on('-m [month]', Integer) {|v| options[:m] = v}
opt.on('-y [year]', Integer) {|v| options[:y] = v}
opt.parse(ARGV)

today = Date.today
month = options[:m] || today.month
year = options[:y] || today.year

first_date = Date.new(year, month, 1)
last_date = Date.new(year, month, -1)

puts "#{month}月 #{year}".center(20)
puts "日 月 火 水 木 金 土"
print "   " * first_date.wday

first_date.upto(last_date) do |date|
  print date.day.to_s.rjust(2)
  if date.saturday?
    print "\n"
  else
    print " "
  end
end
