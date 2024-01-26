#!/usr/bin/env ruby

# frozen_string_literal: true

require 'optparse'

def main
  args = ARGV
  options = parse_options
  options = { l: true, w: true, c: true } if options.empty?

  display_args_counts(args, options)
  display_total(args, options) if args.size > 1
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

def display_args_counts(args, options)
  if args.empty?
    args = $stdin.read
    content = contents_counts(args)
    display_counts(content, options)
    puts
  else
    args.each do |arg|
      str = File.read(arg)
      content = contents_counts(str, arg)
      display_counts(content, options)
      print content[:filename]
    end
  end
end

def display_counts(content, options)
  print content[:lines].to_s.rjust(8) if options[:l]
  print content[:words].to_s.rjust(8) if options[:w]
  print content[:bytes].to_s.rjust(8) if options[:c]
end

def display_total(args, options)
  total_count =
    args.map do |arg|
      str = File.read(arg)
      content = contents_counts(str, arg)
      { lines: content[:lines], words: content[:words], bytes: content[:bytes] }
    end

  print total_count.sum { |count| count[:lines] }.to_s.rjust(8) if options[:l]
  print total_count.sum { |count| count[:words] }.to_s.rjust(8) if options[:w]
  print total_count.sum { |count| count[:bytes] }.to_s.rjust(8) if options[:c]
  print ' total'
  puts
end

main
