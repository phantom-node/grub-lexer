# frozen_string_literal: true
# encoding: UTF-8
#--
# This file is automatically generated. Do not modify it.
# Generated by: oedipus_lex version 2.6.1.
# Source: lib/boot_parser/driver/grub/lexer.rex
#++

module BootParser
  module Driver
    class Grub

# Indentation has to be zeroed for lexer generator to work


##
# The generated lexer Lexer

class Lex
  require 'strscan'

  # :stopdoc:
  NORMAL_VAR     = /[[:alpha:]_][[:alnum:]_]*/
  POSITIONAL_VAR = /[0-9]+/
  SPECIAL_VAR    = /#|@|\?|\*/
  VAR            = /#{NORMAL_VAR}|#{POSITIONAL_VAR}|#{SPECIAL_VAR}/
  # :startdoc:
  # :stopdoc:
  class LexerError < StandardError ; end
  class ScanError < LexerError ; end
  # :startdoc:

  ##
  # The file name / path

  attr_accessor :filename

  ##
  # The StringScanner for this lexer.

  attr_accessor :ss

  ##
  # The current lexical state.

  attr_accessor :state

  alias :match :ss

  ##
  # The match groups for the current scan.

  def matches
    m = (1..9).map { |i| ss[i] }
    m.pop until m[-1] or m.empty?
    m
  end

  ##
  # Yields on the current action.

  def action
    yield
  end


  ##
  # The current scanner class. Must be overridden in subclasses.

  def scanner_class
    StringScanner
  end unless instance_methods(false).map(&:to_s).include?("scanner_class")

  ##
  # Parse the given string.

  def parse str
    self.ss     = scanner_class.new str
    self.state  ||= nil

    do_parse
  end

  ##
  # Read in and parse the file at +path+.

  def parse_file path
    self.filename = path
    open path do |f|
      parse f.read
    end
  end

  ##
  # The current location in the parse.

  def location
    [
      (filename || "<input>"),
    ].compact.join(":")
  end

  ##
  # Lex the next token.

  def next_token

    token = nil

    until ss.eos? or token do
      token =
        case state
        when nil then
          case
          when ss.skip(/\\\n/) then
            # do nothing
          when start_of_line? && (ss.skip(/#.*\n/)) then
            # do nothing
          when previous_blank? && (ss.skip(/#.*\n/)) then
            action { [:SEPARATOR, "\n"] }
          when text = ss.scan(/\\(.)/) then
            append_first_match text
          when ss.skip(/\\/) then
            action { raise NothingFollowsEscape }
          when text = ss.scan(/'([^']*)'/) then
            append_first_match text
          when ss.skip(/'/) then
            action { raise UnmatchedSingleQuote }
          when ss.skip(/\$"/) then
            [:state, :QUOTE]
          when ss.skip(/"/) then
            action { enter_state :QUOTE, raise_if_remain: UnmatchedDoubleQuote }
          when text = ss.scan(/\${(#{VAR})}|\$(#{VAR})/) then
            handle_variable text
          when ss.skip(/\$/) then
            action { raise InvalidVariableName }
          when text = ss.scan(/\n|;/) then
            action { handle_meta(:SEPARATOR, text) }
          when text = ss.scan(/{/) then
            action { handle_meta(:BEGIN, text) }
          when text = ss.scan(/}/) then
            action { handle_meta(:END, text) }
          when text = ss.scan(/&|<|>|\|/) then
            action { handle_meta(:META, text) }
          when text = ss.scan(/[ \t]+/) then
            handle_blank text
          when text = ss.scan(/(.)/) then
            append_first_match text
          else
            text = ss.string[ss.pos .. -1]
            raise ScanError, "can not match (#{state.inspect}) at #{location}: '#{text}'"
          end
        when :QUOTE then
          case
          when ss.skip(/\\(\n)/) then
            # do nothing
          when text = ss.scan(/\\(\$)/) then
            append_first_match text
          when text = ss.scan(/\\(")/) then
            append_first_match text
          when text = ss.scan(/\\(\\)/) then
            append_first_match text
          when text = ss.scan(/\${(#{VAR})}|\$(#{VAR})/) then
            handle_variable text
          when text = ss.scan(/"/) then
            leave_state text
          when text = ss.scan(/(.|\n)/) then
            append_first_match text
          else
            text = ss.string[ss.pos .. -1]
            raise ScanError, "can not match (#{state.inspect}) at #{location}: '#{text}'"
          end
        else
          raise ScanError, "undefined state at #{location}: '#{state}'"
        end # token = case state

      next unless token # allow functions to trigger redo w/ nil
    end # while

    raise LexerError, "bad lexical result at #{location}: #{token.inspect}" unless
      token.nil? || (Array === token && token.size >= 2)

    # auto-switch state
    self.state = token.last if token && token.first == :state

    token
  end # def next_token
end # class

      end
    end
  end
