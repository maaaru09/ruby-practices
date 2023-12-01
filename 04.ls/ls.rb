#!/usr/bin/env ruby

# frozen_string_literal: true

COLUMN_COUNT = 3
def main
  files = Dir.glob('*')
  columns = slice_files(files, COLUMN_COUNT)
  display_columns(columns)
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
