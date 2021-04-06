#!/usr/bin/env ruby

require 'nokogiri'
require 'open-uri'
require 'colorize'
require 'tty-box'
require './lib/file_reader.rb'

if ARGV[0].nil?
  puts TTY::Box.warn('There is no file passed to check.')
else
  checking_file = FileReader.new(ARGV[0])
end
