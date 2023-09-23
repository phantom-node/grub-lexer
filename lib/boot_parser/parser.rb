# frozen_string_literal: true

module BootParser
  class Parser
    def call
      entries = [Entry::Linux.new, Entry::Linux.new]
      config_class.new(entries, default_entry: entries.first)
    end

    private

    attr_reader :config_class

    def initialize(config_class: Config)
      @config_class = config_class
    end
  end
end
