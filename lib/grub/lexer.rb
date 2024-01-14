# frozen_string_literal: true

require_relative "lexer/version"

if defined? Grub::Lexer::AUTOLOADERS
  require "zeitwerk"
  Grub::Lexer::AUTOLOADERS << Zeitwerk::Loader.for_gem_extension(Grub).tap do |loader|
    loader.ignore("#{__dir__}/**/*.rex.rb")
    loader.setup
  end
else
  require_relative "../basic_loader"
end

module Grub
  class Lexer
    def parse(content)
      worker.parse(content)
    end

    def parse_file(file)
      worker.parse_file(file)
    end

    def next_token
      token = worker.call
      return unless token
      [token.first, expand(token.last)]
    end

    private

    def expand(value)
      arg = word_checker.call(value) ? value.parts : [value]
      value_builder.call arg
    end

    attr_reader :worker, :word_checker, :value_builder

    def initialize(
      expander = ->(v) { "${#{v}}" },
      worker: Lex.new,
      word_checker: ->(v) { v.is_a? Word },
      value_builder: ->(arg) { TokenValue.new(arg, expander) }
    )
      @worker = worker
      @word_checker = word_checker
      @value_builder = value_builder
    end
  end
end
