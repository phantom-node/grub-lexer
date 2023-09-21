# frozen_string_literal: true

require "boot_parser/version"

if defined? BootParser::AUTOLOADERS
  require "zeitwerk"
  BootParser::AUTOLOADERS << Zeitwerk::Loader.for_gem.tap do |loader|
    loader.ignore("#{__dir__}/basic_loader.rb")
    loader.setup
  end
else
  require "basic_loader"
end

module BootParser
  class Error < StandardError; end
  # Your code goes here...
end
