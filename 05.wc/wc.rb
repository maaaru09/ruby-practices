#!/usr/bin/env ruby

# frozen_string_literal: true

require 'optparse'

def main
  args = ARGV
  options = parse_options
  str = $stdin.read if args.empty?

  options_or_args_none(args, options, str)
  display_standard_input(args, options, str)
  display_args_count(args, options)
  display_total_count(args, options) if args.size > 1
end

def parse_options
  ARGV.getopts('lwc')
end

def contents_counts(str, arg = '')
  {
    lines: str.count("\n"),
    words: str.split(/\s+/).size,
    bytes: str.bytesize,
    filename: " #{arg}\n"
  }
end

def options_or_args_none(args, options, str)
  display_no_args_standard_input_count(str) if args.empty? && !(options['l'] || options['w'] || options['c'])
  display_no_options_args_count(args) unless options['l'] || options['w'] || options['c']
end

def display_no_options_args_count(args)
  line_sum = 0
  word_sum = 0
  byte_sum = 0
  args.each do |arg|
    str = File.read(arg)
    content = contents_counts(str, arg)
    line_sum += content[:lines]
    word_sum += content[:words]
    byte_sum += content[:bytes]
    print content[:lines].to_s.rjust(8)
    print content[:words].to_s.rjust(8)
    print content[:bytes].to_s.rjust(8)
    print content[:filename]
  end

  return unless args.size > 1

  print line_sum.to_s.rjust(8)
  print word_sum.to_s.rjust(8)
  print byte_sum.to_s.rjust(8)
  print ' total'
end

def display_no_args_standard_input_count(str)
  content = contents_counts(str)
  print content[:lines].to_s.rjust(8)
  print content[:words].to_s.rjust(8)
  print content[:bytes].to_s.rjust(8)
end

def display_standard_input(args, options, str)
  return unless args.empty?

  content = contents_counts(str)
  print content[:lines].to_s.rjust(8) if options['l']
  print content[:words].to_s.rjust(8) if options['w']
  print content[:bytes].to_s.rjust(8) if options['c']
  puts
end

def display_args_count(args, options)
  args.each do |arg|
    str = File.read(arg)
    content = contents_counts(str, arg)
    print content[:lines].to_s.rjust(8) if options['l']
    print content[:words].to_s.rjust(8) if options['w']
    print content[:bytes].to_s.rjust(8) if options['c']
    print content[:filename] if options['l'] || options['w'] || options['c']
  end
end

def display_total_count(args, options)
  line_sum = 0
  word_sum = 0
  byte_sum = 0
  args.each do |arg|
    str = File.read(arg)
    content = contents_counts(str)
    line_sum += content[:lines]
    word_sum += content[:words]
    byte_sum += content[:bytes]
  end
  print line_sum.to_s.rjust(8) if options['l']
  print word_sum.to_s.rjust(8) if options['w']
  print byte_sum.to_s.rjust(8) if options['c']
  print ' total' if options['l'] || options['w'] || options['c']
  puts
end

main
