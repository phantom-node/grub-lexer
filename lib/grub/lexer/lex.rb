# frozen_string_literal: true

require_relative "lex.rex"

module Grub
  class Lexer
    class Lex
      UnmatchedSingleQuote = Class.new StandardError
      UnmatchedDoubleQuote = Class.new StandardError
      NothingFollowsEscape = Class.new StandardError
      InvalidVariableName = Class.new StandardError

      alias_method :raw_next_token, :next_token
      private :raw_next_token

      def next_token
        token = next_non_state_token
        return token if token
        raise state_remain_exception if state_remain_exception
        [word_type, word!] if word.present?
      end

      private

      def next_non_state_token
        token = nil
        loop do
          token = raw_next_token
          next if token && token[0] == :state
          break
        end
        token
      end

      def handle_meta(type, text)
        return [type, text] if word.blank?
        ss.unscan
        [word_type, word!]
      end

      def handle_blank(_)
        word.present? ? [word_type, word!] : nil
      end

      def handle_variable(_)
        var = match[1] || match[2]
        word.variable(var)
        nil
      end

      def append_first_match(_)
        word.append match[1]
        nil
      end

      def word
        @word ||= word_builder.call
      end

      def word!
        word.tap { @word = word_builder.call }
      end

      def start_of_line?
        !previous_char || previous_char == "\n"
      end

      def previous_blank?
        [" ", "\t"].include? previous_char
      end

      def previous_char
        return if ss.charpos < 1
        ss.string[ss.charpos - 1]
      end

      def enter_state(name, raise_if_remain: nil)
        @state_remain_exception = raise_if_remain
        [:state, name]
      end

      def leave_state(_)
        @state_remain_exception = nil
        [:state, nil]
      end

      attr_reader :state_remain_exception

      # Empty method required by lexer generator
      def do_parse
      end

      attr_reader :word_type, :word_builder

      def initialize(word_type: :WORD, word_builder: -> { Word.new })
        @word_type = word_type
        @word_builder = word_builder
      end
    end
  end
end
