#!/usr/bin/env ruby

# frozen_string_literal: true

require 'optparse'

COLUMN_COUNT = 3
def main
  files = fetch_files
  columns = slice_files(files, COLUMN_COUNT)
  display_columns(columns)
end

def fetch_files
  option = ARGV.getopts('a')
  option['a'] ? option_a : Dir.glob('*')
end

def option_a
  Dir.glob('*', File::FNM_DOTMATCH)
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

main
