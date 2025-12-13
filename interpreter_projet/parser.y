%{
#include <stdio.h>
#include <string.h>

// Forward declaration for the lexer function
int yylex(void);

// Forward declaration for the error handling function
void yyerror(const char *s);

// Declaration for the function to scan a string
extern int yy_scan_string(const char*);

// Helper function to remove leading/trailing quotes from a string
char* unquote(char* s) {
    if (s && s[0] == '"') {
        s++;
        size_t len = strlen(s);
        if (len > 0 && s[len-1] == '"') {
            s[len-1] = '\0';
        }
    }
    return s;
}

%}

// Define the types for our union
%union {
    char *sval;
    int ival;
    float fval;
}

// Associate tokens with their types in the union
%token <sval> T_IDENTIFIER T_STRING
%token <ival> T_INTEGER
%token <fval> T_FLOAT

// Language keywords
%token T_FUNC T_DEFINE T_IF T_ELIF T_EL T_WAIT T_PUSH T_PULL T_RETURN T_DEF T_PRINT
%token T_PIXIE T_OUT T_ARROW T_COLON_GT

// Operators and symbols
%token T_EQ T_NEQ T_GT T_LT T_GTE T_LTE T_ASSIGN
%token T_COLON T_SEMICOLON T_GT_COLON T_SLASH_COLON
%token T_LBRACE T_RBRACE T_LPAREN T_RPAREN

// Define the type for non-terminals that return a value
%type <sval> variable_assignment
%type <sval> raw_statements

%start program

%%

program:
    statements
    ;

statements:
    | statements statement
    ;

statement:
    function_definition
    | variable_definition T_SEMICOLON
    | variable_assignment T_SEMICOLON { fprintf(stderr, "--- Parsed a variable assignment for '%s'.\n", $1); }
    | print_statement
    | package_definition
    | pull_statement
    ;

pull_statement:
    T_PULL T_IDENTIFIER T_SEMICOLON
    {
        char* filename = strcat(strdup($2), ".mxp");
        FILE *fp = fopen(filename, "r");
        if (fp != NULL) {
            fseek(fp, 0, SEEK_END);
            long size = ftell(fp);
            fseek(fp, 0, SEEK_SET);

            char* buffer = (char*) malloc(size + 1);
            fread(buffer, 1, size, fp);
            buffer[size] = 0;
            fclose(fp);

            fprintf(stderr, "--- Pulling package '%s'...\n", $2);
            yy_scan_string(buffer);
            free(buffer);
        } else {
            fprintf(stderr, "--- Error pulling package '%s': File not found.\n", $2);
        }
    }
    ;

package_definition:
    T_PIXIE T_ARROW T_IDENTIFIER T_COLON_GT T_LBRACE raw_statements T_RBRACE T_PUSH T_OUT T_IDENTIFIER T_SEMICOLON
    {
        fprintf(stderr, "--- Creating package file for '%s'.\n", $10);
        char* filename = strcat(strdup($10), ".mxp");
        FILE *fp = fopen(filename, "w");
        if (fp != NULL) {
            fprintf(fp, "// Package '%s'\n%s", $10, $6);
            fclose(fp);
            fprintf(stderr, "--- Package '%s' pushed out to %s\n", $10, filename);
        } else {
            fprintf(stderr, "--- Error creating package file for '%s'\n", $10);
        }
    }
    ;

raw_statements:
    { $$ = strdup(""); }
    | raw_statements T_PRINT T_STRING T_SEMICOLON 
    {
        char* new_str;
        asprintf(&new_str, "%sprint %s;\n", $1, $3);
        $$ = new_str;
    }
    ;


print_statement:
    T_PRINT T_STRING T_SEMICOLON { printf("%s\n", unquote($2)); }
    ;

function_definition:
    T_FUNC T_IDENTIFIER T_LPAREN RPAREN T_GT_COLON T_LBRACE function_body T_RBRACE T_COLON T_RETURN T_IDENTIFIER T_SEMICOLON
    { fprintf(stderr, "--- Parsed function '%s'.\n", $2); }
    ;

function_body:
    | function_body statement
    ;

variable_assignment:
    T_PUSH T_STRING T_EQ T_IDENTIFIER { $$ = $4; }
    | T_PUSH T_INTEGER T_EQ T_IDENTIFIER { $$ = $4; }
    ;


variable_definition:
    T_DEFINE T_IDENTIFIER T_ASSIGN value { fprintf(stderr, "--- Parsed definition for variable '%s'.\n", $2); }
    ;

value:
    T_STRING
    | T_INTEGER
    | T_FLOAT
    ;


// Dummy rule to allow for optional parentheses in function calls (for future use)
RPAREN:
    T_RPAREN
    | 
    ;

%%

int main(void) {
    fprintf(stderr, "--- MixieLang Interpreter ---\n");
    yyparse();
    fprintf(stderr, "--- Parsing Complete ---\n");
    return 0;
}

void yyerror(const char *s) {
    fprintf(stderr, "Parse error: %s\n", s);
}
