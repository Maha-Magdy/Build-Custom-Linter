#!/usr/bin/env ruby

require 'nokogiri'
require 'open-uri'
require 'colorize'
require 'tty-box'
require './lib/file_reader'
require './lib/reviewer'

if ARGV[0].nil?
  puts TTY::Box.warn('There is no file passed to check.')
else
  checking_file = FileReader.new(ARGV[0])
end

if checking_file.error_message.empty?
  # Reviewer.proper_structure(checking_file)
  # Reviewer.declare_correct_doctype(checking_file)
  Reviewer.close_tags(checking_file)
  puts  checking_file.error_message
end
