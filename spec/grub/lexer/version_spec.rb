# frozen_string_literal: true

RSpec.describe BootParser do
  it "has a version number" do
    expect(described_class::LEXER_VERSION).not_to be nil
  end
end
