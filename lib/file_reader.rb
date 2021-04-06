require 'colorize'

class FileReader
  attr_reader :file_path, :file, :error_message
  def initialize(file_path)
    @file_path = file_path
    begin
      @file = Nokogiri::HTML.parse(open(@file_path))
    rescue
      @file = nil
      @error_message = 'The passed file isn\'t working! Can you check the file name or path again?'
    end
  end
end
