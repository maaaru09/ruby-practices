#!/usr/bin/env ruby

require "date"
require 'optparse'

# オプションの設定
opt = OptionParser.new
opt.on('-m')
opt.on('-y')
opt.parse!(ARGV)

mon_option = ARGV[0].to_i
year_option = ARGV[1].to_i

# デフォルトの設定
today = Date.today
if mon_option == 0
  mon_option = today.mon
end

if year_option == 0
  year_option = today.year
end

# カレンダーを表示するコード
day1 = Date.new(year_option, mon_option, 1)
day31 = Date.new(year_option, mon_option, -1)
days = [*day1..day31]
youbi = ["日", "月", "火", "水", "木", "金", "土"]

puts "#{mon_option}月 #{year_option}".center(20)
puts youbi.join(' ')
print "   " * day1.wday
days.each do |day|
  if day.saturday?
    print "#{day.strftime('%-d')}\n".to_s.rjust(3)
  else
    print "#{day.strftime('%-d')}".to_s.center(3)
  end
end
