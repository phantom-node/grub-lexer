# frozen_string_literal: true

module Grub
  RSpec.describe Lexer do
    it "has a version number" do
      expect(described_class::VERSION).not_to be nil
    end
  end
end
