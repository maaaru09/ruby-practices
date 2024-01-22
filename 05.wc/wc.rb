#!/usr/bin/env ruby

# frozen_string_literal: true

require 'optparse'

def main
  args = ARGV
  options = parse_options
  options = { l: true, w: true, c: true } if options.empty?

  if args.empty?
    str = $stdin.read
    display_standard_input_count(options, str)
  else
    display_args_count(args, options)
  end

  total_display(args, options) if args.size > 1
end

def parse_options
  opt = OptionParser.new

  params = {}
  opt.on('-l')
  opt.on('-w')
  opt.on('-c')

  opt.parse!(ARGV, into: params)
  params
end

def contents_counts(str, arg = '')
  {
    lines: str.count("\n"),
    words: str.split(/\s+/).size,
    bytes: str.bytesize,
    filename: " #{arg}\n"
  }
end

def display_standard_input_count(str, options)
  content = contents_counts(str)
  print content[:lines].to_s.rjust(8) if options[:l]
  print content[:words].to_s.rjust(8) if options[:w]
  print content[:bytes].to_s.rjust(8) if options[:c]
  puts
end

def display_args_count(args, options)
  args.each do |arg|
    str = File.read(arg)
    content = contents_counts(str, arg)
    print content[:lines].to_s.rjust(8) if options[:l]
    print content[:words].to_s.rjust(8) if options[:w]
    print content[:bytes].to_s.rjust(8) if options[:c]
    print content[:filename]
  end
end

def total_display(args, options)
  line_sum = 0
  word_sum = 0
  byte_sum = 0
  args.each do |arg|
    str = File.read(arg)
    content = contents_counts(str, arg)
    line_sum += content[:lines]
    word_sum += content[:words]
    byte_sum += content[:bytes]
  end
  print line_sum.to_s.rjust(8) if options[:l]
  print word_sum.to_s.rjust(8) if options[:w]
  print byte_sum.to_s.rjust(8) if options[:c]
  print ' total'
end

main
