#include <stdio.h>
#include <string.h>

// Forward declarations for the parsers
int yyparse(void);
int yyimageparse(void);
int yyparse_audio(void);

// Forward declarations for lexer functions
extern int yylex(void);
extern int yyimagelex(void);

// Forward declaration for the function to set the input file
extern FILE *yyin;

// Helper function to get file extension
const char *get_filename_ext(const char *filename) {
    const char *dot = strrchr(filename, '.');
    if(!dot || dot == filename) return "";
    return dot + 1;
}

int main(int argc, char **argv) {
    if (argc > 2 && strcmp(argv[1], "-f") == 0) {
        const char* filename = argv[2];
        FILE *file = fopen(filename, "r");
        if (!file) {
            fprintf(stderr, "Could not open file: %s\n", filename);
            return 1;
        }
        yyin = file;

        const char* ext = get_filename_ext(filename);

        fprintf(stderr, "--- MixieLang Interpreter ---\n");

        if (strcmp(ext, "mxpg") == 0) {
            fprintf(stderr, "--- Parsing Image File (.mxpg) ---\n");
            yyimageparse();
        } else if (strcmp(ext, "mp5x") == 0) {
            fprintf(stderr, "--- Parsing Audio File (.mp5x) ---\n");
            // yyparse_audio(); // Placeholder for audio parser
        } else {
            fprintf(stderr, "--- Parsing Code File (.mx) ---\n");
            yyparse();
        }

        fclose(file);

    } else {
        fprintf(stderr, "--- MixieLang Interpreter (stdin) ---\n");
        yyparse();
    }

    fprintf(stderr, "--- Parsing Complete ---\n");
    return 0;
}

void yyerror(const char *s) {
    fprintf(stderr, "Parse error: %s\n", s);
}
