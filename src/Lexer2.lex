import java_cup.runtime.*;

%%
%class Lexer
%unicode
%cup
%debug
%line
%column
%states IN_COMMENT
%states STRING
%{
  private boolean debug_mode;
  public boolean debug() {  return debug_mode; }
  public void debug (boolean mode) { debug_mode = mode; }

  StringBuffer string = new StringBuffer();
  private Symbol symbol(int type) {
    return new Symbol(type, yyline, yycolumn);
  }
  private Symbol symbol(int type, Object value) {
    return new Symbol(type, yyline, yycolumn, value);
  }
%}

Whitespace = \r|\n|\r\n|" "|"\t"
Comment = "#"[^\r\n]*

Character = [a-zA-Z]
Digit = [0-9]
PositiveInteger = (1-9){Digit}*
Integer = 0|[-]?{PositiveInteger}
Rational = [Integer[_]]?[{PositiveInteger}[/]{PositiveInteger}]
Float = {Integer}[.][[0]*PositiveInteger]
Identifier = {Character}[{Digit}|{Character}|_]*
Char = '[\x00-\x7F]'



%%



<YYINITIAL> {
    "break"              {return symbol(sym.BREAK);}

    "T"                  {return symbol(sym.TRUE);}
    "F"                  {return symbol(sym.FALSE);}
    "let"                {return symbol(sym.LET);}
    "top"                {return symbol(sym.TOP);}
    "len"                {return symbol(sym.LEN);}
    "dict"               {return symbol(sym.DIC);}
    "seq"                {return symbol(sym.SEQ);}
    "range"              {return symbol(sym.RANGE);}
    "thread"             {return symbol(sym.THREAD);}
    "return"             {return symbol(sym.RETURN);}
    "print"              {return symbol(sym.PRINT);}
    "read"               {return symbol(sym.READ);}

    "int"                {return symbol(sym.TINT);}
    "float"              {return symbol(sym.TFLOAT);}
    "rational"           {return symbol(sym.TRATIONAL);}
    "char"               {return symbol(sym.TCHAR);}
    "str"                {return symbol(sym.TSTR);}
    "bool"               {return symbol(sym.TBOOL);}

    "fdef"               {return symbol(sym.FUNC);}
    "tdef"               {return symbol(sym.TYPE);}
    "alias"              {return symbol(sym.ALIAS);}

    "for"                {return symbol(sym.FOR);}
    "while"              {return symbol(sym.WHILE);}
    "in"                 {return symbol(sym.IN);}
    "if"                 {return symbol(sym.IF);}

    ":="                 {return symbol(sym.ASSIGN);}

    "+"                  {return symbol(sym.ADD);}
    "-"                  {return symbol(sym.SUB);}
    "/"                  {return symbol(sym.DIV);}
    "*"                  {return symbol(sym.MUL);}
    "^"                  {return symbol(sym.POW);}

    "!"                  {return symbol(sym.NOT);}
    "&&"                 {return symbol(sym.AND);}
    "||"                 {return symbol(sym.OR);}

    "="                  {return symbol(sym.EQ);}
    "!="                 {return symbol(sym.NOTEQ);}
    "<"                  {return symbol(sym.LT);}
    "<="                 {return symbol(sym.LE);}
    ">"                  {return symbol(sym.GT);}
    ">="                 {return symbol(sym.GE);}

    "("                  {return symbol(sym.LPAREN);}
    ")"                  {return symbol(sym.RPAREN);}
    "["                  {return symbol(sym.LSQBKT);}
    "]"                  {return symbol(sym.RSQBKT);}
    "{"                  {return symbol(sym.LCURL);}
    "}"                  {return symbol(sym.RCURL);}

    ":"                  {return symbol(sym.COLON);}
    ";"                  {return symbol(sym.SEMI);}
    ","                  {return symbol(sym.COMMA);}

    \"                   {string.setLength(0); yybegin(STRING);}

    {Identifier}         {return symbol(sym.IDENTIFIER);}
    {Whitespace}         {                                       }
    {Comment}            {                                       }
    {Char}               {return symbol(sym.CHAR);}
    {Integer}              {return symbol(sym.FLOAT);}
}

<STRING> {
      \"                             { yybegin(YYINITIAL);
                                       return symbol(sym.STRING,
                                       string.toString()); }
      [^\n\r\"\\]+                   { string.append( yytext() ); }
      \\t                            { string.append('\t'); }
      \\n                            { string.append('\n'); }

      \\r                            { string.append('\r'); }
      \\\"                           { string.append('\"'); }
      \\                             { string.append('\\'); }
    }

/* error fallback */
[^]  {
    System.out.println("Error in line "
        + (yyline+1) +": Invalid input '" + yytext()+"'");
    return symbol(sym.ILLEGAL_CHARACTER);
}
