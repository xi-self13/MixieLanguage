#!/bin/bash

# Exit immediately if a command fails
set -e

# Create the bin directory if it doesn't exist
mkdir -p bin

# --- Generate C code from Flex and Bison files ---
echo "Generating C code from Flex and Bison files..."

# The -d flag tells bison to generate the header file (parser.tab.h)
bison -d --defines=interpreter_projet/parser.tab.h -o interpreter_projet/parser.tab.c interpreter_projet/parser.y

# Generate the C code from the lexer file
flex -o interpreter_projet/lex.yy.c interpreter_projet/lexer.l

# --- Compile the C code into an executable ---
echo "Compiling the interpreter..."

# Compile the generated C files.
# The -I flag tells gcc where to look for header files.
# The -L flag tells gcc where to look for libraries.
# -lfl links the flex library
gcc -o bin/mixie-interpreter interpreter_projet/parser.tab.c interpreter_projet/lex.yy.c -Iinterpreter_projet -L/nix/store/21l5snjs8ngip4qysl71dlhvfp2ci63a-flex-2.6.4/lib -lfl

echo "Interpreter build complete."
