# frozen_string_literal: true

module Grub
  RSpec.describe Lexer do
    subject(:lexer) {
      args = expander ? [expander] : []
      described_class.new(*args, worker: worker, word_checker: ->(_) { word? })
    }

    let(:expander) { nil }

    it "parses config and returns tokens" do
      lexer = described_class.new
      lexer.parse('sleep "$zzz"')
      tokens = [lexer.next_token, lexer.next_token]
      expect(tokens).to eq([[:WORD, "sleep"], [:WORD, "${zzz}"]])
    end

    context "with nil token" do
      let :worker do
        -> {}
      end

      it "returns nil" do
        expect(lexer.next_token).to be_nil
      end
    end

    context "with text token" do
      let :worker do
        -> { [:TYPE, "text"] }
      end

      let(:word?) { false }

      it "recognizes it as text" do
        expect(lexer.next_token).to eq([:TYPE, "text"])
      end

      it "marks token value as non-expandable" do
        token = lexer.next_token
        expect(token.last.expandable?).to eq(false)
      end
    end

    context "with token containing variable" do
      let :worker do
        word = OpenStruct.new(parts: ["text1", :var, "text2"])
        -> { [:TYPE, word] }
      end

      let(:word?) { true }

      it "expands variable using default expander" do
        expect(lexer.next_token).to eq([:TYPE, "text1${var}text2"])
      end

      it "marks token value as expandable" do
        token = lexer.next_token
        expect(token.last.expandable?).to eq(true)
      end

      context "with custom expander" do
        let :expander do
          ->(v) { "<#{v}>" }
        end

        it "expands variable using it" do
          expect(lexer.next_token).to eq([:TYPE, "text1<var>text2"])
        end
      end
    end
  end
end
