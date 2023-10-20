# frozen_string_literal: true

require_relative "lexer/version"

if defined? Grub::Lexer::AUTOLOADERS
  require "zeitwerk"
  Grub::Lexer::AUTOLOADERS << Zeitwerk::Loader.for_gem_extension(Grub).tap do |loader|
    loader.ignore("#{__dir__}/**/*.rex.rb")
    loader.setup
  end
else
  require "basic_loader"
end

module Grub
  class Lexer
  end
end
