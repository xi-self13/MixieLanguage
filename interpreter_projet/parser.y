%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

// Forward declarations
int yylex(void);
void yyerror(const char *s);
extern int yy_scan_string(const char*);

// Simple in-memory data store for blocks
#define MAX_BLOCKS 100
char* block_names[MAX_BLOCKS];
char* block_contents[MAX_BLOCKS];
int block_count = 0;

void store_block(char* name, char* content) {
    if (block_count < MAX_BLOCKS) {
        block_names[block_count] = strdup(name);
        block_contents[block_count] = strdup(content);
        block_count++;
    }
}

char* retrieve_block(char* name) {
    for (int i = 0; i < block_count; i++) {
        if (strcmp(block_names[i], name) == 0) {
            return block_contents[i];
        }
    }
    return NULL;
}

// Helper function to unquote strings
char* unquote(char* s) {
    if (s && s[0] == '\"') {
        s++;
        size_t len = strlen(s);
        if (len > 0 && s[len-1] == '\"') {
            s[len-1] = '\0';
        }
    }
    return s;
}

%}

// Union of possible token types
%union {
    char *sval;
    int ival;
    float fval;
}

// Token type definitions
%token <sval> T_IDENTIFIER T_STRING T_CONTENT
%token <ival> T_INTEGER
%token <fval> T_FLOAT

// Keywords
%token T_FUNC T_DEFINE T_IF T_ELIF T_EL T_WAIT T_PUSH T_PULL T_RETURN T_DEF T_PRINT
%token T_PIXIE T_PIXPIX T_OUT T_ARROW T_COLON_GT T_SLASH_GT
%token T_AT T_END

// Operators and Symbols
%token T_EQ T_NEQ T_GT T_LT T_GTE T_LTE T_ASSIGN
%token T_COLON T_SEMICOLON T_GT_COLON T_SLASH_COLON
%token T_LBRACE T_RBRACE T_LPAREN T_RPAREN T_COMMA

// Start symbol
%start program

%%

program:
    blocks
    ;

blocks:
    /* empty */
    | blocks block
    ;

block:
    T_AT T_IDENTIFIER T_COLON T_IDENTIFIER T_CONTENT T_END
    {
        store_block($4, $5);
        fprintf(stderr, "--- Stored block: %s\n", $4);
    }
    | T_AT T_IDENTIFIER T_COLON T_IDENTIFIER T_END
    {
        store_block($4, "");
        fprintf(stderr, "--- Stored empty block: %s\n", $4);
    }
    | statements
    ;

statements:
    /* empty */
    | statements statement
    ;

statement:
    package_definition
    | print_statement T_SEMICOLON
    | pull_statement T_SEMICOLON
    ;

pull_statement:
    T_PULL T_AT T_IDENTIFIER T_COLON T_IDENTIFIER
    {
        char* content = retrieve_block($5);
        if (content != NULL) {
            printf("%s\n", content);
        } else {
            fprintf(stderr, "--- Error pulling block '%s': Not found.\n", $5);
        }
    }
    ;

package_definition:
    T_PIXIE T_ARROW T_IDENTIFIER T_COLON_GT T_LBRACE package_body T_RBRACE T_PUSH T_OUT T_IDENTIFIER T_SEMICOLON
    {
        fprintf(stderr, "--- Creating package file for '%s'.\n", $10);
        char* filename = strcat(strdup($10), ".mxp");
        FILE *fp = fopen(filename, "w");
        if (fp != NULL) {
            fprintf(fp, "// Package '%s' created by the Mixie compiler\n", $10);
            // TODO: Write package_body content to file
            fclose(fp);
            fprintf(stderr, "--- Package '%s' pushed out to %s\n", $10, filename);
        } else {
            fprintf(stderr, "--- Error creating package file for '%s'\n", $10);
        }
    }
    ;

package_body:
    /* empty */
    | package_statements
    ;

package_statements:
    package_statement
    | package_statements package_statement
    ;

package_statement:
    pixpix_definition
    ;

pixpix_definition:
    T_PIXPIX T_GT T_IDENTIFIER T_LPAREN T_COLON T_IDENTIFIER T_RPAREN T_SLASH_GT T_LBRACE function_body T_RBRACE
    {
        fprintf(stderr, "--- Parsed pixpix function '%s'.\n", $3);
    }
    ;

function_body:
    /* empty */
| inner_statements
    ;

inner_statements:
    inner_statement
    | inner_statements inner_statement
    ;

inner_statement:
    print_statement
    ;

print_statement:
    T_PRINT T_STRING
    {
        printf("%s\n", unquote($2));
    }
    ;

%%