# frozen_string_literal: true

require "boot_parser/lexer_version"

if defined? BootParser::LEXER_AUTOLOADERS
  require "zeitwerk"
  BootParser::LEXER_AUTOLOADERS << Zeitwerk::Loader.for_gem.tap do |loader|
    loader.inflector.inflect "lexer_version" => "LEXER_VERSION"
    loader.ignore("#{__dir__}/basic_loader.rb")
    loader.ignore("#{__dir__}/**/*.rex.rb")
    loader.setup
  end
else
  require "basic_loader"
end

module BootParser
  class Error < StandardError; end
  # Your code goes here...
end
