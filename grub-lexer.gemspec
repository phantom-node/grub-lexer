# frozen_string_literal: true

require_relative "lib/grub/lexer_version"

Gem::Specification.new do |spec|
  spec.name = "grub-lexer"
  spec.version = Grub::LEXER_VERSION
  spec.authors = ["Paweł Pokrywka"]
  spec.email = ["pepawel@users.noreply.github.com"]

  spec.summary = "Parse boot loader configuration and return list of boot entries."
  spec.homepage = "https://phantomno.de/grub-lexer"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.7.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/phantom-node/grub-lexer"
  spec.metadata["changelog_uri"] = "https://github.com/phantom-node/grub-lexer/blob/master/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
