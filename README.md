# jlox Interpreter

This is the implementation of the jlox interpreter from the book [Crafting Interpreters](https://craftinginterpreters.com/).

This README is mainly to take notes while I read the book.

### Compilers in general

* [Reference to computer science text book](https://craftinginterpreters.com/scanning.html#regular-languages-and-expressions): the [dragon book](https://en.wikipedia.org/wiki/Compilers:_Principles,_Techniques,_and_Tools)

### Lexing

* [Handling longer lexems and lookahead](https://craftinginterpreters.com/scanning.html#longer-lexemes)

### Grammar

* [Explanation of grammars with brekfast options](https://craftinginterpreters.com/representing-code.html#rules-for-grammars)

#### List of expressions

- **Literals:** Numbers, strings, Booleans, and nil.
- **Unary expressions:** A prefix ! to perform a logical not, and - to negate a number.
- **Binary expressions:** The infix arithmetic (+, -, *, /) and logic operators (==, !=, <, <=, >, >=) we know and love.
- **Parentheses:** A pair of ( and ) wrapped around an expression.

#### Lox grammar

```
expression     → literal
               | unary
               | binary
               | grouping ;

literal        → NUMBER | STRING | "true" | "false" | "nil" ;
grouping       → "(" expression ")" ;
unary          → ( "-" | "!" ) expression ;
binary         → expression operator expression ;
operator       → "==" | "!=" | "<" | "<=" | ">" | ">="
               | "+"  | "-"  | "*" | "/" ;
```

#### Run Expr class generation tool

```bash
$ cd src
$ javac com/craftinginterpreters/tool/GenerateAst.java
$ java com.craftinginterpreters.tool.GenerateAst com/craftinginterpreters/lox
```

### Error handling

* [On the location of the errors](https://craftinginterpreters.com/scanning.html#location-information): "Some token implementations store the location as two numbers: the offset from the beginning of
the source file to the beginning of the lexeme, and the length of the lexeme. The scanner needs to
know these anyway, so there’s no overhead to calculate them."

* [Reporting all errors](https://craftinginterpreters.com/scanning.html#lexical-errors): "Note also that we keep scanning. There may be other errors later in the program."

### Programming

* [static imports considered bad style](https://craftinginterpreters.com/scanning.html#the-scanner-class)
* [Ternary as a function argument](https://craftinginterpreters.com/scanning.html#operators): `addToken(match('=') ? BANG_EQUAL : BANG);`
