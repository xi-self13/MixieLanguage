%{{
#include "image_parser.tab.h"
#include <stdio.h>
%}}

%option noyywrap prefix="yyimage"

%%

"(startofimagedata" { return T_IMAGE_START; }
"EOID)"             { return T_IMAGE_END; }
"structure;/->"    { return T_STRUCTURE; }
"("                { return T_LPAREN; }
")"                { return T_RPAREN; }

[^\n]+             { /* Ignore other content for now */ }
[ \t\r\n]+          { /* Skip whitespace */ }

.                  { printf("Unexpected character in image: %c\n", *yytext); }

%%