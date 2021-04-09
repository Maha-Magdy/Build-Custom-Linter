require 'nokogiri'
require 'open-uri'
require 'colorize'
require 'tty-box'
require 'ruby-progressbar'
require './lib/file_reader'
require './lib/reviewer'

system 'clear'
system 'cls'

progressbar = ProgressBar.create

if ARGV[0].nil?
  puts TTY::Box.warn('There is no file passed to check.')
else
  checking_file = FileReader.new(ARGV[0])

  if checking_file.error_message.empty?
    # rubocop:disable Style/Semicolon
    10.times { progressbar.increment; sleep 0.02 }
    Reviewer.proper_structure(checking_file)
    10.times { progressbar.increment; sleep 0.02 }
    Reviewer.declare_correct_doctype(checking_file)
    10.times { progressbar.increment; sleep 0.02 }
    Reviewer.close_tags(checking_file)
    10.times { progressbar.increment; sleep 0.02 }
    Reviewer.avoid_inline_style(checking_file)
    10.times { progressbar.increment; sleep 0.02 }
    Reviewer.check_alt_attribute_with_images(checking_file)
    10.times { progressbar.increment; sleep 0.02 }
    Reviewer.check_external_style_sheets_place(checking_file)
    10.times { progressbar.increment; sleep 0.02 }
    Reviewer.use_lowercase_tag_names(checking_file)
    10.times { progressbar.increment; sleep 0.02 }
    if checking_file.error_message.any?
      20.times { progressbar.increment; sleep 0.02 }
      # rubocop:disable Layout/LineLength
      puts TTY::Box.error("× Found #{checking_file.error_message.length} error. Try to fix it to have clean code \n\n#{checking_file.error_message.join("\n\n")}", padding: 1)
      # rubocop:enable Layout/LineLength
    else
      20.times { progressbar.increment; sleep 0.05 }
      puts TTY::Box.success('No offenses detected')
    end
  else
    100.times { progressbar.increment; sleep 0.025 }
    # rubocop:enable Style/Semicolon
    puts TTY::Box.warn(checking_file.error_message.join.to_s)
  end
end
