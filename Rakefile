# frozen_string_literal: true

require "standard/rake"
require "bundler/gem_tasks"
require "rspec/core/rake_task"
Rake.application.rake_require "oedipus_lex"

Rake::Task.define_task :validate_loader do
  abort "Basic loader is stale, run `bin/loader generate` to fix" unless system("bin/loader validate")
end
Rake::Task[:build].enhance [:validate_loader]

RSpec::Core::RakeTask.new(:spec)

task generate_lexers: ["lib/grub/lexer/lex.rex.rb"]
task spec: :generate_lexers

task default: %i[spec]
