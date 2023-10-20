# frozen_string_literal: true

module Grub
  class Lexer
    class Lex
      class Word
        attr_reader :parts

        def append(text)
          parts << text.to_s
        end

        def variable(v)
          parts << v.to_sym
        end

        def present?
          !blank?
        end

        def blank?
          parts.empty?
        end

        private

        def initialize
          @parts = []
        end
      end
    end
  end
end
