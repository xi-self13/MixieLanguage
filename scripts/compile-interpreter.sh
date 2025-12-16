#!/bin/bash

# Exit immediately if a command fails
set -e

# Create the bin directory if it doesn't exist
mkdir -p bin

# --- Generate C code from Flex and Bison files ---
echo "Generating C code from Flex and Bison files..."

# === Main Parser ===
echo "Generating C code for Main Parser..."
bison -d --defines=interpreter_projet/parser.tab.h -o interpreter_projet/parser.tab.c interpreter_projet/parser.y
flex -o interpreter_projet/lex.yy.c interpreter_projet/lexer.l

# === Image Parser ===
echo "Generating C code for Image Parser..."
bison -d --defines=interpreter_projet/image_parser.tab.h -o interpreter_projet/image_parser.tab.c interpreter_projet/image_parser.y
flex -o interpreter_projet/image_lex.yy.c interpreter_projet/image_lexer.l

# --- Compile the C code into an executable ---
echo "Compiling the interpreter..."

gcc -o bin/mixie-interpreter \
    interpreter_projet/parser.tab.c \
    interpreter_projet/lex.yy.c \
    interpreter_projet/image_parser.tab.c \
    interpreter_projet/image_lex.yy.c \
    interpreter_projet/main.c \
    -Iinterpreter_projet \
    -L/nix/store/21l5snjs8ngip4qysl71dlhvfp2ci63a-flex-2.6.4/lib \
    -lfl

echo "Interpreter build complete."
