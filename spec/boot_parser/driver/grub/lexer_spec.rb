# frozen_string_literal: true

module BootParser
  module Driver
    class Grub
      RSpec.describe Lexer do
        subject(:lexer) { described_class.new }

        def self.configs
          glob = File.join(__dir__, "fixtures", "*.cfg")
          Dir.glob(glob).map do |name|
            File.basename(name)
          end
        end

        configs.each do |example|
          it "produces valid token sequence for #{example}" do
            config, serialized_tokens = split_file(example)
            actual_tokens = simplify tokenize(config)
            expected_tokens = eval(serialized_tokens) # standard:disable Security/Eval
            expect(actual_tokens).to eq(expected_tokens)
          end
        end

        it "raises exception when variable name is invalid" do
          expect do
            tokenize("${variable name with spaces}")
          end.to raise_error(described_class::ScanError)
        end

        private

        def split_file(file)
          path = File.join(__dir__, "fixtures", file)
          content = File.read(path)
          config, tokens = content.split("---")
          raise "Invalid format: #{path}" unless tokens.is_a?(String)
          [config.chop, tokens]
        end

        def tokenize(config)
          lexer.parse config
          result = []
          while (token = lexer.next_token)
            result << token
          end
          result
        end

        let :expander do
          ->(var) { "{{ #{var} }}" }
        end

        def simplify(tokens)
          tokens.map do |type, value|
            value = value.respond_to?(:render) ? value.render(expander) : value
            [type, value]
          end
        end
      end
    end
  end
end
