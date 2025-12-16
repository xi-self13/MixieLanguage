%{
#include <stdio.h>

// Forward declarations
int yyimagelex(void);
void yyimageerror(const char *s);

%}

%define api.prefix "yyimage"

%token T_IMAGE_START T_IMAGE_END T_STRUCTURE T_LPAREN T_RPAREN

%start image_file

%%

image_file:
    T_IMAGE_START image_content T_IMAGE_END
    {
        printf("--- Successfully parsed .mxpg file ---\n");
    }
    ;

image_content:
    /* empty */
    | image_content image_statement
    ;

image_statement:
    T_STRUCTURE T_LPAREN T_RPAREN
    {
        printf("--- Parsed image structure ---\n");
    }
    ;

%%

void yyimageerror(const char *s) {
    fprintf(stderr, "Image parse error: %s\n", s);
}
