# frozen_string_literal: true

module BootParser
  class Config
    attr_reader :entries, :default_entry

    private

    def initialize(entries, default_entry:)
      @entries = entries
      @default_entry = default_entry
    end
  end
end
