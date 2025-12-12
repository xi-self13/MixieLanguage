# New Language Specification

## Language Name

MixieLang (Mixie for Short)

## File Extension

.mx

## File Structure

A `.mx` file is a container that can hold different types of data, such as code, images, and audio. The file is organized into blocks, each with a header that specifies the type of content in that block.

### Block Structure

Each block in a `.mx` file has the following structure:

`@<type>:<name> [encoding]`
`... content ...`
`@end`

- `<type>`: The type of data (e.g., `code`, `image`, `audio`).
- `<name>`: A unique name for the block.
- `[encoding]`: (Optional) How the content is encoded, e.g., `base64` for binary data.

### Accessing Blocks

Data from blocks can be loaded into your code using the `pull` keyword followed by the block's type and name.

`pull @image:logo`

## Syntax

### Keywords

- `fund`/`func`: Defines a function.
- `define`: Defines a variable within a function.
- `if`/`elif`/`el`: Used for conditional logic.
- `wait`: Pauses program execution.
- `push`: Assigns a value to a variable.
- `pull`: Imports a package or loads a data block.

### Data Types

- **String**, **Integer**, **Float**, **Boolean**, **Array**, **Object**, **Null**.

### Operators

- `>>` (Equals), `!>>` (Not Equals), `>` (Greater Than), `<` (Less Than), `>>=` (Greater Than or Equal To), `<<=` (Less Than or Equal To).

### Comments

- `^`: Single-line comment.
- `^** ... **^`: Multi-line comment.
- `^$ ... $^`: System comments for configuring the interpreter.

## Functions

Functions are defined using the `fund` (or `func`) keyword. The return value is specified after the function body.

**Expert Style:**
`fund funcName(attributes) >: { ... }: return what?;`

**Beginner Style (with explicit types):**
`fund def FuncName(attributes : type) >: { ... } ret what?;`

## Variables and Scope

- **Assignment**: `push "hello, mixie" > varname`
- **Retrieval**: `pull var <varname>`

## Example Code

This example shows a `.mx` file containing an image and the code to load it.

```mixie
^$ +=beginner $^

@image:logo base64
^**
  (imagine a long string of base64 data here representing an image)
**^
@end

@code:main
^ This function loads the image data from the 'logo' block
fund def loadImage(name: string) >: {
    define imageData = pull @image:name;
    ^ imageData now holds the base64 data
    print("Image loaded!");
} ret null;

^ The main entry point for the program
fund main() >: {
    ^ Call the function to load the logo
    loadImage("logo");
}: return null;

```