# MixieLang

Welcome to MixieLang, a lightweight, interpreted scripting language designed for simplicity and ease of use. This guide will walk you through the basics of the language and its package management system.

## Getting Started

To start using MixieLang, you can run the interpreter from the command line:

```bash
./mxsh -f <your_script>.mx
```

## Core Syntax

### Comments

Comments in MixieLang start with a `^` symbol and extend to the end of the line.

```mixie
^ This is a comment
```

### Printing to the Console

The `print` command outputs text to the console.

```mixie
print "Hello, World!";
```

### Variable Assignment

Variables can be assigned using the `push` keyword.

```mixie
push "my_variable_value" >> my_variable;
```

## Package Management

MixieLang includes a simple package management system that allows you to organize and reuse your code.

### Creating a Package

To create a package, use the `pixie` keyword, followed by the package name and a code block. The `push out` command creates a new `.mxp` file containing the package's code.

```mixie
pixie -> MyPackage :> {
    print "This code is inside a package!";
} push out MyPackage;
```

When you run a file with this code, a new file named `MyPackage.mxp` will be created.

### Using a Package

To use a package in your code, use the `pull` keyword followed by the package name.

```mixie
pull MyPackage;
```

This will make the code within the `MyPackage` package available to your script.

## Putting It All Together

Here's an example of how to define a package and then use it in a separate file.

**1. Create the package (`create_package.mx`):**

```mixie
pixie -> Greeter :> {
    print "Hello from the Greeter package!";
} push out Greeter;
```

**2. Run the script to create the package file:**

```bash
./mxsh -f create_package.mx
```

This will create a `Greeter.mxp` file.

**3. Use the package in another file (`main.mx`):**

```mixie
pull Greeter;
```

**4. Run the main script:**

```bash
./mxsh -f main.mx
```

This will print "Hello from the Greeter package!" to the console.

## Future Development

The MixieLang package management system is still under active development. Future updates will include more advanced features, such as:

*   **Exporting and importing specific functions and variables from packages.**
*   **Versioning and dependency management.**
*   **A central package repository.**

We hope you enjoy using MixieLang! If you have any questions or feedback, please don't hesitate to reach out.
