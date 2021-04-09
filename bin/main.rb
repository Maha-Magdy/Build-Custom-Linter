#!/usr/bin/env ruby

require 'nokogiri'
require 'open-uri'
require 'colorize'
require 'tty-box'
require './lib/file_reader'
require './lib/reviewer'

system 'clear'
system 'cls'

if ARGV[0].nil?
  puts TTY::Box.warn('There is no file passed to check.')
else
  checking_file = FileReader.new(ARGV[0])
end

if checking_file.error_message.empty?
  Reviewer.proper_structure(checking_file)
  Reviewer.declare_correct_doctype(checking_file)
  Reviewer.close_tags(checking_file)
  Reviewer.avoid_inline_style(checking_file)
  Reviewer.check_alt_attribute_with_images(checking_file)
  Reviewer.check_external_style_sheets_place(checking_file)
  Reviewer.use_lowercase_tag_names(checking_file)
  if checking_file.error_message.any?
    # rubocop:disable Layout/LineLength
    puts TTY::Box.error("× Found #{checking_file.error_message.length} error. Try to fix it to have clean code \n\n#{checking_file.error_message.join("\n\n")}", padding: 1)
    # rubocop:enable Layout/LineLength
  else
    puts TTY::Box.success('No offenses detected')
  end
else
  puts TTY::Box.warn(checking_file.error_message.join('').to_s)
end
