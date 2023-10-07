# frozen_string_literal: true

require_relative "lexer.rex"

module BootParser
  module Driver
    class Grub
      class Lexer
        alias_method :raw_next_token, :next_token
        private :raw_next_token

        def next_token
          token = raw_next_token
          return token if token
          [word_type, word!] if word.present?
        end

        private

        def handle_meta(type, text)
          return [type, text] if word.blank?
          back
          [word_type, word!]
        end

        def handle_blank(_)
          word.present? ? [word_type, word!] : nil
        end

        def handle_variable(_)
          var = match[1] || match[2]
          word.variable(var)
        end

        def word
          @word ||= Word.new
        end

        def word!
          word.tap { @word = Word.new }
        end

        def back
          ss.pos -= 1
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
