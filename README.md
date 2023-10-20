# Grub::Lexer

[![Gem Version](https://badge.fury.io/rb/grub-lexer.svg)](https://badge.fury.io/rb/grub-lexer)

Convert Grub boot loader configuration into tokens that can be fed into the parser.

## Installation

Install the gem and add to the application's Gemfile by executing:

    bundle add grub-lexer

If bundler is not being used to manage dependencies, install the gem by executing:

    gem install grub-lexer

## Usage

### Basic example

    require "grub/lexer"
    lexer = Grub::Lexer.new
    lexer.parse "sleep 1"
    lexer.next_token   # => [:WORD, "sleep"]
    lexer.next_token   # => [:WORD, "1"]
    lexer.next_token   # => nil

### Loading configuration from file

    require "grub/lexer"
    lexer = Grub::Lexer.new
    lexer.parse_file "/boot/grub/grub.cfg"

### Variables expansion

    require "grub/lexer"
    expander = ->(var) { var == :greeting ? "hello" : "awesome" }
    lexer = Grub::Lexer.new expander
    lexer.parse %{echo "$greeting ${adjective} world!"\n}
    lexer.next_token   # => [:WORD, "echo"]
    lexer.next_token   # => [:WORD, "hello awesome world!"]
    lexer.next_token   # => [:SEPARATOR, "\n"]

### Variables detection and per-call expanders

    require "grub/lexer"
    lexer = Grub::Lexer.new ->(_) { "same" }
    lexer.parse '$var1 text "$var2 text"'
    token = lexer.next_token                 # => [:WORD, "same"]
    token[1].expandable?                     # => true
    token = lexer.next_token                 # => [:WORD, "text"]
    token[1].expandable?                     # => false
    token = lexer.next_token                 # => [:WORD, "same text"]
    token[1].to_s(->(v) { v.to_s.upcase })   # => "VAR2 text"

## Limitations

Only Grub 2 is supported. Grub Legacy may work, but hasn't been tested.

The gem doesn't support Grub translations.
I18n strings (`$"translation key"`) are treated like normal strings in double quotes.

Only subset of metacharacters are recognized as distinct token types.
However, implementation of missing metacharacter types is trivial.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bundle exec rake spec` to run
the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update
the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for
the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at <https://github.com/phantom-node/grub-lexer>. This project
is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to
the [code of conduct](https://github.com/[USERNAME]/grub-lexer/blob/master/CODE_OF_CONDUCT.md).

## Author

My name is Paweł Pokrywka and I'm the author of grub-lexer.

If you want to contact me or get to know me better, check out
[my blog](https://blog.pawelpokrywka.com).

Thank you for your interest in this project :)

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Grub project's codebases, issue trackers, chat rooms and mailing lists is expected to
follow the [code of conduct](https://github.com/[USERNAME]/grub-lexer/blob/master/CODE_OF_CONDUCT.md).
