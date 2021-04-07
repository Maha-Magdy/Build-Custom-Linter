require 'strscan'
module Reviewer 
  def self.proper_structure(checking_file)
    unless checking_file.file_data.join('').match(/(.*)<html>(.*)<head>(.*)<title>(.*)<\/title>(.*)<\/head>(.*)<body>(.*)<\/body>(.*)<\/html>/m)
      checking_file.error_message << 'The page will not render correctly in every browser so it\'s important to be consistent using the proper document structure.'
    end
  end

  def self.declare_correct_doctype(checking_file)
    if checking_file.file_data[0].match(/<!DOCTYPE/).nil?
      checking_file.error_message << 'Declare the doctype to tell the browser the standards you are using to render your markup correctly.'
    elsif checking_file.file_data[0].match(/<!DOCTYPE html/).nil?
      checking_file.error_message << 'Declare the correct doctype for an HTML document'
    end
  end

  def self.close_tags(checking_file)
    self_closing_tags = ['area', 'base', 'br', 'col', 'command', 'embed', 'hr', 'img', 'input', 'keygen', 'link', 'meta', 'param', 'source', 'track', 'wbr'];
    non_self_open_tags = Hash.new(0)
    non_self_closing_tags = Hash.new(0)

    checking_file.file_data.each do |line|
      open_tag_name = line.downcase.scan(/<[a-z]+>/).join('').delete('<>')
      close_tag_name = line.downcase.scan(/<\/[a-z]+>/).join('').delete('<>\/')

      unless open_tag_name.empty?
        i = 0
        while i < self_closing_tags.length do 
          open_tag_name = '' if open_tag_name == self_closing_tags[i]
          i += 1
        end
      end

      non_self_open_tags[open_tag_name] += 1 unless open_tag_name.empty?
      non_self_closing_tags[close_tag_name] += 1 unless close_tag_name.empty?

    end
    puts non_self_open_tags
    puts non_self_closing_tags
  end
end

