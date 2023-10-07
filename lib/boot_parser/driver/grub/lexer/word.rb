# frozen_string_literal: true

module BootParser
  module Driver
    class Grub
      class Lexer
        class Word
          def append(text)
            elements << text.to_s
            nil
          end

          def variable(v)
            elements << v.to_sym
            nil
          end

          def render(variables)
            elements.map do |element|
              element.is_a?(Symbol) ? variables[element] : element
            end.join
          end

          def present?
            !blank?
          end

          def blank?
            elements.empty?
          end

          private

          attr_reader :elements

          def initialize
            @elements = []
          end
        end
      end
    end
  end
end
