require 'strscan'
require 'nokogiri'
require 'open-uri'

module Reviewer
  def self.proper_structure(checking_file)
    # rubocop:disable Layout/LineLength
    checking_file.error_message << 'The page will not render correctly in every browser so it\'s important to be consistent using the proper document structure.' unless checking_file.file_data.join('').match(/(.*)(<html>)|(HTML)(.*)(<head>)|(<HEAD>)(.*)(<title>)|(<TITLE>)(.*)(<\/title>)|(<\/TITLE>)(.*)(<\/head>)|(<\/HEAD>)(.*)(<body>)|(BODY)(.*)(<\/body>)|(\/BODY)(.*)(<\/html>)|(<\/HTML>)/m)
    # rubocop:ensable Layout/LineLength
  end

  def self.declare_correct_doctype(checking_file)
    if checking_file.file_data[0].match(/<!DOCTYPE/).nil?
      checking_file.error_message << 'Declare the doctype to tell the browser the standards you are using to render your markup correctly.'
    elsif checking_file.file_data[0].match(/<!DOCTYPE html/).nil?
      checking_file.error_message << 'Declare the correct doctype for an HTML document'
    end
  end

  def self.close_tags(checking_file)
    self_closing_tags = %w[area base br col command embed hr img input keygen link meta param source track wbr]
    non_self_open_tags = Hash.new(0)
    non_self_closing_tags = Hash.new(0)

    checking_file.file_data.each do |line|
      open_tag_names = line.downcase.scan(/<[a-zA-Z]+/)
      open_tag_names.each do |open_tag_name|
        open_tag_name = open_tag_name.delete('<')

        unless open_tag_name.empty?
          i = 0
          while i < self_closing_tags.length
            open_tag_name = '' if open_tag_name == self_closing_tags[i]
            i += 1
          end
        end

        non_self_open_tags[open_tag_name] += 1 unless open_tag_name.empty?
      end

      close_tag_names = line.downcase.scan(/<\/[a-z]+>/)
      close_tag_names.each do |close_tag_name|
        close_tag_name = close_tag_name.delete('<>\/')
        non_self_closing_tags[close_tag_name] += 1 unless close_tag_name.empty?
      end
    end
    check_close_tags(checking_file, non_self_open_tags, non_self_closing_tags)
  end

  def self.check_close_tags(checking_file, open_tags, close_tags)
    i = 0
    while i < open_tags.keys.length
      if open_tags[open_tags.keys[i]] > close_tags[open_tags.keys[i]]
        missing_number = open_tags[open_tags.keys[i]] - close_tags[open_tags.keys[i]]
        checking_file.error_message << "Missing #{missing_number} closing tags for element #{open_tags.keys[i]}."
      end
      i += 1
    end

    i = 0
    while i < close_tags.keys.length
      if close_tags[close_tags.keys[i]] > open_tags[close_tags.keys[i]]
        extra_number = close_tags[close_tags.keys[i]] - open_tags[close_tags.keys[i]]
        checking_file.error_message << "Unneeded extra #{extra_number} closing tags for element #{close_tags.keys[i]}. Check before you delete it/them may be you missed to put opening tag for it/them."
      end
      i += 1
    end
  end

  def self.avoid_inline_style(checking_file)
    checking_file.file_data.each_with_index do |link, index|
      unless link.to_s.match(/(style=(\s)*"(.*)")|(style=(\s)*'(.*)')/).nil?
        checking_file.error_message << "At line #{index + 1} Existing inline styles. Don't use inline styles because it makes it harder to update and maintain a file."
      end
    end
  end

  def self.check_alt_attribute_with_images(checking_file)
    file_data = Nokogiri::HTML(URI.open(checking_file.file_path))
    file_data.css('img').each do |link|
      if link.to_s.match(/(alt(\s)*=(\s)*"(.)+")|(alt(\s)*=(\s)*'(.*)')/).nil?
        checking_file.error_message << "At line #{link.line}, An <img> element must have a meaningful alt attribute for validation and accessibility reasons."
      end
    end
  end

  def self.check_external_style_sheets_place(checking_file)
    file_data = Nokogiri::HTML(URI.open(checking_file.file_path))

    all_style_sheets = file_data.css('link').count
    style_sheets_inside_head = file_data.css('head').css('link').count
    checking_file.error_message << 'Place all external style sheets within the <head> tag' if all_style_sheets > style_sheets_inside_head
  end

  def self.use_lowercase_tag_names(checking_file)
    checking_file.file_data.each_with_index do |line, index|

      unless line.scan(/<[a-zA-Z]+/).join('').delete('<').match(/[A-Z]+/).nil?
        tag_name = line.scan(/<[a-zA-Z]+/).join('')
        # rubocop:disable Layout/LineLength
        checking_file.error_message << "At line #{index + 1}, uppercase characters have been used with #{tag_name}>. keep tag names in lowercase because it is easier to read and maintain."
        # rubocop:enable Layout/LineLength
      end

      unless line.scan(/<\/[a-zA-Z]+>/).join('').delete('<>\/').match(/[A-Z]+/).nil?
        tag_name = line.scan(/<\/[a-zA-Z]+>/).join('')
        # rubocop:disable Layout/LineLength
        checking_file.error_message << "At line #{index + 1}, uppercase characters have been used with #{tag_name}. keep tag names in lowercase because it is easier to read and maintain."
        # rubocop:enable Layout/LineLength
      end
    end
  end
end
