class Parser

token IF ELSE
token DEF
token CLASS
token NEWLINE
token NUMBER
token STRING
token TRUE FALSE NIL
token IDENTIFIER
token CONSTANT
token INDENT DEDENT

prechigh
  left '.'
  right '!'
  left '*' '/'
  left '+' '-'
  left '>' '>=' '<' '<='
  left '==' '!='
  left '&&'
  left '||'
  right '='
  left ','
preclow

rule

Root:
  /* nothing */                           { result = Nodes.new([]) }
  | Expressions                           { result = val[0] }
  ;

Expressions:
  Expression                              { result = Nodes.new(val) }
  | Expressions Terminator Expression     { result = val[0] << val[2] }
  | Expressions Terminator                { result = val[0] }
  | Terminator                            { result = Nodes.new([]) }
  ;

Expression:
  Literal
  | Call
  | Operator
  | Constant
  | Assign
  | Def
  | Class
  | If
  | '(' Expression ')'                    { result = val[1] }
  ;

#TODO: Come back here, and just verify that you can use '' rather than ""
Terminator:
  NEWLINE
  | ";"
  ;

Literal:
  NUMBER                                  { result = NumberNode.new(val[0]) }
  | STRING                                { result = StringNode.new(val[0]) }
  | TRUE                                  { result = TrueNode.new }
  | FALSE                                 { result = FalseNode.new }
  | NIL                                   { result = NilNode.new }
  ;

Call:
  IDENTIFIER                                    { result = CallNode.new(nil, val[0], []) }
  | IDENTIFIER "(" ArgList ")"                  { result = CallNode.new(nil, val[0], [2]) }
  | Expression "." IDENTIFIER                   { result = CallNode.new(val[0], val[2], []) }
  | Expression "." IDENTIFIER "(" ArgList ")"   { result = CallNode.new(val[0], val[2], val[4]) }
  ;

ArgList:
  /* Nothing */                           { result = [] }
  | Expression                            { result = val }
  | ArgList "," Expression                { result = val[0] << val[2] }
  ;

Operator:
  # Binary operators
  Expression '||' Expression              { result = CallNode.new(val[0], val[1], [val[2]]) }
  | Expression '&&' Expression            { result = CallNode.new(val[0], val[1], [val[2]]) }
  | Expression '==' Expression            { result = CallNode.new(val[0], val[1], [val[2]]) }
  | Expression '!=' Expression            { result = CallNode.new(val[0], val[1], [val[2]]) }
  | Expression '>' Expression             { result = CallNode.new(val[0], val[1], [val[2]]) }
  | Expression '>=' Expression            { result = CallNode.new(val[0], val[1], [val[2]]) }
  | Expression '<' Expression             { result = CallNode.new(val[0], val[1], [val[2]]) }
  | Expression '<=' Expression            { result = CallNode.new(val[0], val[1], [val[2]]) }
  | Expression '+' Expression             { result = CallNode.new(val[0], val[1], [val[2]]) }
  | Expression '-' Expression             { result = CallNode.new(val[0], val[1], [val[2]]) }
  | Expression '*' Expression             { result = CallNode.new(val[0], val[1], [val[2]]) }
  | Expression '/' Expression             { result = CallNode.new(val[0], val[1], [val[2]]) }
  ;

Constant:
  CONSTANT                                { result = GetConstantNode.new(val[0]) }
  ;

# Assignment to a variable or constant
Assign:
  IDENTIFIER "=" Expression       { result = SetLocalNode.new(val[0], val[2]) }
  | CONSTANT "=" Expression       { result = SetConstantNode.new(val[0], val[2]) }
  ;

  # Method definition
Def:
  DEF IDENTIFIER Block          { result = DefNode.new(val[1], [], val[2]) }
  | DEF IDENTIFIER
      "(" ParamList ")" Block     { result = DefNode.new(val[1], val[3], val[5]) }
  ;

ParamList:
  /* nothing */                 { result = [] }
  | IDENTIFIER                    { result = val }
  | ParamList "," IDENTIFIER      { result = val[0] << val[2] }
  ;

  # Class definition
Class:
  CLASS CONSTANT Block          { result = ClassNode.new(val[1], val[2]) }
  ;

  # if block
If:
  IF Expression Block           { result = IfNode.new(val[1], val[2]) }
  ;

  # A block of indented code. You see here that all the hard work was done by the
  # lexer.
Block:
  INDENT Expressions DEDENT     { result = val[1] }
  # If you don't like indentation you could replace the previous rule with the
  # following one to separate blocks w/ curly brackets. You'll also need to remove the
  # indentation magic section in the lexer.
  # "{" Expressions "}"           { replace = val[1] }
  ;
  end

---- header
require "lexer"
require "nodes"

---- inner
# This code will be put as-is in the Parser class.
def parse(code, show_tokens=false)
  @tokens = Lexer.new.tokenize(code) # Tokenize the code using our lexer
  puts @tokens.inspect if show_tokens
  do_parse # Kickoff the parsing process
end

def next_token
  @tokens.shift
end
