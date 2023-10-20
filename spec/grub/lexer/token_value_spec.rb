# frozen_string_literal: true

module Grub
  class Lexer
    RSpec.describe TokenValue do
      def value(parts, expander = ->(v) { "{#{v}}" })
        described_class.new(parts, expander)
      end

      it "renders with parts empty" do
        expect(value([])).to eq("")
      end

      it "renders nil part" do
        expect(value([nil])).to eq("")
      end

      it "renders blank part" do
        expect(value([""])).to eq("")
      end

      it "renders mix of nil and blank parts" do
        expect(value(["", nil, "", ""])).to eq("")
      end

      it "renders text" do
        expect(value(["text"])).to eq("text")
      end

      it "expands variable" do
        expect(value([:var])).to eq("{var}")
      end

      it "renders parts consisting of variable and text" do
        expect(value([:var, "text"])).to eq("{var}text")
      end

      it "renders parts consisting of text and variable" do
        expect(value(["text", :var])).to eq("text{var}")
      end

      it "renders parts consisting of text and variables with random nils and blanks" do
        expect(value([:var, "", nil, "text", nil])).to eq("{var}text")
      end

      it "accepts passing per-call expander" do
        instance = value [:var, "text"]
        expander = ->(v) { "<#{v}>" }
        expect(instance.to_s(expander)) == "<var>text"
      end
    end
  end
end
