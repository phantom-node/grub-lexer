# frozen_string_literal: true

module BootParser
  module Driver
    class Grub
      class Lex
        class Word
          def append(text)
            elements << text.to_s
          end

          def variable(v)
            elements << v.to_sym
          end

          def render(expander)
            elements.map do |element|
              element.is_a?(Symbol) ? expander.call(element) : element
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
