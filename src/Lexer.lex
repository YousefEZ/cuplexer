import java_cup.runtime.*;

%%
%class Lexer
%unicode
%cup
%line
%column
%states IN_COMMENT
%states STRING
%{
  StringBuffer string = new StringBuffer();
  private Symbol symbol(int type) {
    return new Symbol(type, yyline, yycolumn);
  }
  private Symbol symbol(int type, Object value) {
    return new Symbol(type, yyline, yycolumn, value);
  }
%}

LineTerminator = \r|\n|\r\n
Whitespace = {LineTerminator} | [ \t\f]
Comment = ("#"[^\r\n]*)|("/#"[^"#/"]*"#/")
Character = [a-z|A-Z]
Digit = [0-9]
PositiveInteger = (1-9){Digit}*
Integer = 0|([1-9]{Digit}*)
Float = {Integer}["."]{Digit}+
Identifier = {Character}[{Digit}|{Character}|"_"]*
Rational = ((0|([1-9][0-9]*))[_]([1-9][0-9]*){Whitespace}*["\/"]{Whitespace}*([1-9][0-9]*))
Char = '[\w]'


%%



<YYINITIAL> {
    "break"              {return symbol(sym.BREAK);}

    "T"                  {return symbol(sym.TRUE);}
    "F"                  {return symbol(sym.FALSE);}
    "top"                {return symbol(sym.TOP);}
    "dict"               {return symbol(sym.DICT);}
    "seq"                {return symbol(sym.SEQ);}
    "range"              {return symbol(sym.RANGE);}
    "thread"             {return symbol(sym.THREAD);}
    "return"             {return symbol(sym.RETURN);}
    "print"              {return symbol(sym.PRINT);}
    "read"               {return symbol(sym.READ);}
    "main"               {return symbol(sym.MAIN);}
    "len"                {return symbol(sym.LEN);}
    "wait"               {return symbol(sym.WAIT);}
    "."                  {return symbol(sym.DOT);}

    "int"                {return symbol(sym.TINT);}
    "float"              {return symbol(sym.TFLOAT);}
    "rat"                {return symbol(sym.TRATIONAL);}
    "char"               {return symbol(sym.TCHAR);}
    "str"                {return symbol(sym.TSTR);}
    "bool"               {return symbol(sym.TBOOL);}
    "void"               {return symbol(sym.VOID);}

    "fdef"               {return symbol(sym.FDEF);}
    "tdef"               {return symbol(sym.TDEF);}
    "alias"              {return symbol(sym.ALIAS);}

    "for"                {return symbol(sym.FOR);}
    "of"                 {return symbol(sym.OF);}
    "while"              {return symbol(sym.WHILE);}
    "in"                 {return symbol(sym.IN);}
    "if"                 {return symbol(sym.IF);}
    "elif"               {return symbol(sym.ELIF);}
    "else"               {return symbol(sym.ELSE);}

    ":="                 {return symbol(sym.ASSIGN);}

    "+"                  {return symbol(sym.ADD);}
    "-"                  {return symbol(sym.SUB);}
    "/"                  {return symbol(sym.DIV);}
    "*"                  {return symbol(sym.MUL);}
    "^"                  {return symbol(sym.POW);}

    "!"                  {return symbol(sym.NOT);}
    "?"                  {return symbol(sym.CONTAINS);}
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

    {Identifier}         {return symbol(sym.IDENTIFIER, yytext());}
    {Whitespace}         {                                       }
    {Comment}            {                                       }
    {Rational}           {return symbol(sym.RATIONAL);}
    {Integer}            {return symbol(sym.INTEGER);}
    {Char}               {return symbol(sym.CHAR);}
    {Float}              {return symbol(sym.FLOAT);}


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
