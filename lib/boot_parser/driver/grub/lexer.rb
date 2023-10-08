# frozen_string_literal: true

require_relative "lexer.rex"

module BootParser
  module Driver
    class Grub
      class Lexer
        alias_method :raw_next_token, :next_token
        private :raw_next_token

        def next_token
          token = next_non_state_token
          return token if token
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
          @word ||= Word.new
        end

        def word!
          word.tap { @word = Word.new }
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

        # Empty method required by lexer generator
        def do_parse
        end

        attr_reader :word_type

        def initialize(word_type: :WORD)
          @word_type = word_type
        end
      end
    end
  end
end
