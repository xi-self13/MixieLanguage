%{{
#include "parser.tab.h"
#include <stdio.h>
%}}

%option noyywrap
%x ML_COMMENT
%x SYS_COMMENT

ID      [a-zA-Z_][a-zA-Z0-9_]*
DIGIT   [0-9]

%%

"@"               { return T_AT; }
"@end"            { return T_END; }

"fund"            { return T_FUNC; }
"define"          { return T_DEFINE; }
"if"              { return T_IF; }
"elif"            { return T_ELIF; }
"el"              { return T_EL; }
"wait"            { return T_WAIT; }
"push"            { return T_PUSH; }
"pull"            { return T_PULL; }
"print"           { return T_PRINT; }
"return"          { return T_RETURN; }
"def"             { return T_DEF; }

"pixie"           { return T_PIXIE; }
"pixpix"          { return T_PIXPIX; }
"out"             { return T_OUT; }
"->"              { return T_ARROW; }
":>"              { return T_COLON_GT; }
"/>"              { return T_SLASH_GT; }

">>"              { return T_EQ; }
"!>>"             { return T_NEQ; }
">>="             { return T_GTE; }
"<<="             { return T_LTE; }
">"               { return T_GT; }
"<"               { return T_LT; }

"/:"              { return T_SLASH_COLON; }
">:"              { return T_GT_COLON; }

"{"               { return T_LBRACE; }
"}"               { return T_RBRACE; }
"("               { return T_LPAREN; }
")"               { return T_RPAREN; }
":"               { return T_COLON; }
";"               { return T_SEMICOLON; }
","               { return T_COMMA; }

{ID}              { yylval.sval = strdup(yytext); return T_IDENTIFIER; }
{DIGIT}+          { yylval.ival = atoi(yytext); return T_INTEGER; }
{DIGIT}+"."{DIGIT}+ { yylval.fval = atof(yytext); return T_FLOAT; }
\"[^\"]*\"          { yylval.sval = strdup(yytext); return T_STRING; }

[ \t\r\n]+          { /* Skip whitespace */ }

"^"[^\n]*         { /* Single-line comment */ }
"^**"             { /* Multi-line comment start */ BEGIN(ML_COMMENT); }
<ML_COMMENT>"**^" { /* Multi-line comment end */ BEGIN(INITIAL); }
<ML_COMMENT>.    { /* Ignore content of multi-line comment */ }

"^$"              { /* System comment start */ BEGIN(SYS_COMMENT); }
<SYS_COMMENT>"$"  { /* System comment end */ BEGIN(INITIAL); }
<SYS_COMMENT>.     { /* Ignore content of system comment */ }

.                 { printf("Unexpected character: %c\n", *yytext); }

%%