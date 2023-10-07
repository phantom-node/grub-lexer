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
  /#.*\n/
  /\\\n/
  /\\(.)/                           { word.append match[1] }
  /'([^']*)'/                       { word.append match[1] }
  /\$"/                             :QUOTE # i18n not supported
  /"/                               :QUOTE
  /\${(#{VAR})}|\$(#{VAR})/         handle_variable
  /\$/                              :INVALID_VARIABLE_NAME
  /\n|;/                            { handle_meta(:SEPARATOR, text) }
  /{/                               { handle_meta(:BEGIN, text) }
  /}/                               { handle_meta(:END, text) }
  /&|<|>|\|/                        { handle_meta(:META, text) }
  /[ \t]/                           handle_blank
  /./                               { word.append text }

  :QUOTE /\\\$/                     { word.append '$' }
  :QUOTE /\\"/                      { word.append '"' }
  :QUOTE /\\\\/                     { word.append "\\" }
  :QUOTE /\\\n/                     { word.append "\n" }
  :QUOTE /\${(#{VAR})}|\$(#{VAR})/  handle_variable
  :QUOTE /"/                        nil
  :QUOTE /.|\n/                     { word.append text }

  :INVALID_VARIABLE_NAME /[^\s\S]/  # will never match
end

    end
  end
end
