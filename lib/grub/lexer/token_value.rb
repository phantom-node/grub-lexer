# frozen_string_literal: true

module Grub
  class Lexer
    class TokenValue < String
      def to_s(expander = nil)
        return super() unless expander
        parts.map do |part|
          part.is_a?(Symbol) ? expander.call(part) : part
        end.join
      end

      def expandable?
        parts.any? { |e| e.is_a? Symbol }
      end

      private

      attr_reader :parts, :default_expander

      def initialize(parts, expander)
        @parts = parts
        @default_expander = expander
        super to_s(expander)
      end
    end
  end
end
