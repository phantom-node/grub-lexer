module BootParser
  module Driver
    class Grub

# Indentation has to be zeroed for lexer generator to work
class Lexer

macros
  NORMAL_VAR      /[[:alpha:]_][[:alnum:]_]*/
  POSITIONAL_VAR  /[0-9]+/
  SPECIAL_VAR     /#|@|\?|\*/
  VAR             /#{NORMAL_VAR}|#{POSITIONAL_VAR}|#{SPECIAL_VAR}/

rules
  /\\\n/
  start_of_line?  /#.*\n/
  previous_blank? /#.*\n/           { [:SEPARATOR, "\n"] }
  /\\(.)/                           append_first_match
  /\\/                              { raise NothingFollowsEscape }
  /'([^']*)'/                       append_first_match
  /'/                               { raise UnmatchedSingleQuote }
  /\$"/                             :QUOTE # i18n not supported
  /"/                               { enter_state :QUOTE, raise_if_remain: UnmatchedDoubleQuote }
  /\${(#{VAR})}|\$(#{VAR})/         handle_variable
  /\$/                              { raise InvalidVariableName }
  /\n|;/                            { handle_meta(:SEPARATOR, text) }
  /{/                               { handle_meta(:BEGIN, text) }
  /}/                               { handle_meta(:END, text) }
  /&|<|>|\|/                        { handle_meta(:META, text) }
  /[ \t]+/                          handle_blank
  /(.)/                             append_first_match

  :QUOTE /\\(\n)/
  :QUOTE /\\(\$)/                   append_first_match
  :QUOTE /\\(")/                    append_first_match
  :QUOTE /\\(\\)/                   append_first_match
  :QUOTE /\${(#{VAR})}|\$(#{VAR})/  handle_variable
  :QUOTE /"/                        leave_state
  :QUOTE /(.|\n)/                   append_first_match

end

    end
  end
end
