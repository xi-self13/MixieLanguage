%{
#include <stdio.h>
#include <string.h>

int yylex(void);
void yyerror(const char *s);

// Helper function to remove leading/trailing quotes from a string
char* unquote(char* s) {
    if (s && s[0] == '"') {
        s++; // Move past the opening quote
        size_t len = strlen(s);
        if (len > 0 && s[len-1] == '"') {
            s[len-1] = '\0'; // Remove the closing quote by adding a null terminator
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

// Operators and symbols
%token T_EQ T_NEQ T_GT T_LT T_GTE T_LTE T_ASSIGN
%token T_COLON T_SEMICOLON T_GT_COLON T_SLASH_COLON
%token T_LBRACE T_RBRACE T_LPAREN T_RPAREN

// Define the type for non-terminals that return a value
%type <sval> variable_assignment

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
