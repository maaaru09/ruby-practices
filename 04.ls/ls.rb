#!/usr/bin/env ruby

# frozen_string_literal: true

require 'optparse'

require 'etc'

FILE_PERMISSION = {
  '0' => '---',
  '1' => '-—x',
  '2' => '-w-',
  '3' => '-wx',
  '4' => 'r—-',
  '5' => 'r-x',
  '6' => 'rw-',
  '7' => 'rwx'
}.freeze

FILE_TYPE = {
  '01' => 'p',
  '02' => 'c',
  '04' => 'd',
  '06' => 'b',
  '10' => '-',
  '12' => 'l',
  '14' => 's'
}.freeze

COLUMN_COUNT = 3

def main
  options = parse_options

  files = options['a'] ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')
  files = files.reverse if options['r']

  if options['l']
    display_in_long_format(files)
  else
    columns = slice_files(files, COLUMN_COUNT)
    display_columns(columns)
  end
end

def parse_options
  ARGV.getopts('alr')
end

def slice_files(files, number)
  files << ' ' until (files.size % number).zero?
  files.each_slice(files.size / number).to_a
end

def display_columns(columns)
  column_width = columns.flatten.max_by(&:length).size
  columns.transpose.each do |column|
    column.each do |file|
      print file.ljust(column_width + 1)
    end
    puts
  end
end

def display_in_long_format(files)
  user_id = Process.uid
  user_name = Etc.getpwuid(user_id).name

  group_id = Process.gid
  group_name = Etc.getgrgid(group_id).name

  block = files.map { |file| File.stat(file).blocks }
  puts "total #{block.sum}"

  files.each do |file|
    file_stat = File.stat(file)

    octal_number = file_stat.mode.to_s(8).chars
    octal_number.unshift('0') if octal_number.size == 5

    print FILE_TYPE[octal_number[0] + octal_number[1]], FILE_PERMISSION[octal_number[3]]
    print FILE_PERMISSION[octal_number[4]], FILE_PERMISSION[octal_number[5]]
    print " #{file_stat.nlink.to_s.rjust(2)}"
    print " #{user_name.ljust(user_name.size)}"
    print "  #{group_name}"
    print " #{file_stat.size.to_s.rjust(5)}"
    print " #{file_stat.mtime.strftime('%_m %_d %H:%M')}"
    print " #{file}"
    puts
  end
end

main
