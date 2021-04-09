require './lib/file_reader'
require './lib/reviewer'
# rubocop:disable Layout/LineLength
describe Reviewer do
  let(:checking_clear_file) { FileReader.new('./experiment-files/clear-file.html') }
  let(:checking_unclear_file) { FileReader.new('./experiment-files/unclear-file.html') }

  describe '#proper_structure' do
    it 'There will no be error if a proper structure has been used' do
      Reviewer.proper_structure(checking_clear_file)
      expect(checking_clear_file.error_message.length).to eql(0)
    end

    it 'Will return error if no proper structure has been used' do
      Reviewer.proper_structure(checking_unclear_file)
      expect(checking_unclear_file.error_message).to include 'The page will not render correctly in every browser so it\'s important to be consistent using the proper document structure.'
    end
  end

  describe '#declare_correct_doctype' do
    it 'There will no be error if correct doctype has been declared' do
      Reviewer.declare_correct_doctype(checking_clear_file)
      expect(checking_clear_file.error_message.length).to eql(0)
    end

    it 'Will return error if no doctype has been declared' do
      Reviewer.declare_correct_doctype(checking_unclear_file)
      expect(checking_unclear_file.error_message).to include 'Declare the doctype to tell the browser the standards you are using to render your markup correctly.'
    end
  end

  describe '#close_tags' do
    it 'There will no be error if all non-self closing tags have their own closing tags' do
      Reviewer.close_tags(checking_clear_file)
      expect(checking_clear_file.error_message.length).to eql(0)
    end

    it 'Will return error with the number of missing closing tags of any non-self closing tags have not their own closing tags' do
      Reviewer.close_tags(checking_unclear_file)
      expect(checking_unclear_file.error_message).to include 'Missing 1 closing tags for element head.'
    end
  end

  describe '#avoid_inline_style' do
    it 'There will no be an error if the inline style has been avoided.' do
      Reviewer.avoid_inline_style(checking_clear_file)
      expect(checking_clear_file.error_message.length).to eql(0)
    end

    it 'Will return error with the number of the line in which an inline style has been used.' do
      Reviewer.avoid_inline_style(checking_unclear_file)
      expect(checking_unclear_file.error_message).to include 'At line 6 Existing inline styles. Don\'t use inline styles because it makes it harder to update and maintain a file.'
    end
  end

  describe '#check_alt_attribute_with_images' do
    it 'There will no be an error if all img tags in the page have their alt attribute.' do
      Reviewer.check_alt_attribute_with_images(checking_clear_file)
      expect(checking_clear_file.error_message.length).to eql(0)
    end

    it 'Will return error with a line number of missing the alt attribute. of any img tag in the page has not the alt attribute.' do
      Reviewer.check_alt_attribute_with_images(checking_unclear_file)
      expect(checking_unclear_file.error_message).to include 'At line 6, An <img> element must have alt attribute for validation and accessibility reasons.'
    end
  end

  describe '#check_external_style_sheets_place' do
    it 'There will no be an error if all external style sheets on the page within the head tag.' do
      Reviewer.check_external_style_sheets_place(checking_clear_file)
      expect(checking_clear_file.error_message.length).to eql(0)
    end

    it 'Will return an error if any of the external style sheets on the page not within the head tag.' do
      Reviewer.check_external_style_sheets_place(checking_unclear_file)
      expect(checking_unclear_file.error_message).to include 'Place all external style sheets within the <head> tag'
    end
  end

  describe '#use_lowercase_tag_names' do
    it 'There will no be an error if lowercase characters have been used with all name tags on the page.' do
      Reviewer.use_lowercase_tag_names(checking_clear_file)
      expect(checking_clear_file.error_message.length).to eql(0)
    end

    it 'Will return an error with the line number in which uppercase characters have been used as a name tag.' do
      Reviewer.use_lowercase_tag_names(checking_unclear_file)
      expect(checking_unclear_file.error_message).to include 'At line 2, uppercase characters have been used with <HEAD>. keep tag names in lowercase because it is easier to read and maintain.'
    end
  end
end
# rubocop:enable Layout/LineLength
