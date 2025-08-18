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

[Gramar with precedence:](https://craftinginterpreters.com/parsing-expressions.html#ambiguity-and-the-parsing-game)

```
expression     → equality ;
equality       → comparison ( ( "!=" | "==" ) comparison )* ;
comparison     → term ( ( ">" | ">=" | "<" | "<=" ) term )* ;
term           → factor ( ( "-" | "+" ) factor )* ;
factor         → unary ( ( "/" | "*" ) unary )* ;
unary          → ( "!" | "-" ) unary
               | primary ;
primary        → NUMBER | STRING | "true" | "false" | "nil"
               | "(" expression ")" ;
```

##### Grammar vs Precendence

| TOP     | Equiality      | LOWER      |
| -       | -              | -          |
| ^       | Comparison     | ^          |
| GRAMMAR | Addition       | PRECEDENCE |
| v       | Multiplication | v          |
| BOTTOM  | Unary          | HIGHER     |

A recursive descent parser is a literal translation of the grammar’s rules straight into imperative code. Each rule becomes a function. The body of the rule translates to code roughly like:

| Grammar notation | Code representation               |
| -                | -                                 |
| Terminal         | Code to match and consume a token |
| Nonterminal      | Call to that rule’s function      |
| \|               | if or switch statement            |
| * or +           | while or for loop                 |
| ?	               | if statement                      |

The descent is described as “recursive” because when a grammar rule refers to itself—directly or indirectly—that translates to a recursive function call.

##### Adding statements

```
program        → statement* EOF ;

statement      → exprStmt
               | printStmt ;

exprStmt       → expression ";" ;
printStmt      → "print" expression ";" ;
```

##### Adding declarations (for vqriables)

```
program        → declaration* EOF ;

declaration    → varDecl
               | statement ;

statement      → exprStmt
               | printStmt ;
```

And the rule for declaring a variable:

```
varDecl        → "var" IDENTIFIER ( "=" expression )? ";" ;
```

And update the primary expression:

```
primary        → "true" | "false" | "nil"
               | NUMBER | STRING
               | "(" expression ")"
               | IDENTIFIER ;
```

##### Adding assignments

This says an assignment is either an identifier followed by
an = and an expression for the value, or an equality
(and thus any other) expression.

```
expression     → assignment ;
assignment     → IDENTIFIER "=" assignment
               | equality ;
```

[Check the book section](https://craftinginterpreters.com/statements-and-state.html#assignment-syntax)

The classic terms for these two constructs are l-value and
r-value. All of the expressions that we’ve seen so far that
produce values are r-values. An l-value “evaluates” to a
*storage location* that you can assign into.

We want the syntax tree to reflect that an l-value isn’t
evaluated like a normal expression. That’s why the Expr.Assign
node has a Token for the left-hand side, not an Expr.
The problem is that the parser doesn’t know it’s parsing an
l-value until it hits the =. In a complex l-value, that may
occur many tokens later.

##### Adding block syntax and semantics

```
statement      → exprStmt
               | printStmt
               | block ;

block          → "{" declaration* "}" ;
```

#### Run Expr class generation tool

```bash
$ cd src
$ javac com/craftinginterpreters/tool/GenerateAst.java
$ java com.craftinginterpreters.tool.GenerateAst com/craftinginterpreters/lox
```

### Parser

* [final variables in the Expr nested clases](https://craftinginterpreters.com/representing-code.html#metaprogramming-the-trees): The final keyword (e.g. `final Expr left;`, ensures that a
variable can be assigned a value only once. For instance variables like these, this assignment must happen either at the point of declaration or, as is the case
here, within the constructor. Once the Binary object is created, you cannot change its left, operator, or right fields. Any attempt to reassign them will result in a compile-time error.
By making all fields final and not providing any setter methods, the Binary class becomes immutable. An immutable object is one whose state cannot be modified after it is created.
The `final` variables can be declared at the beginning or the end of the class, that does not matter.

* [Generics](https://craftinginterpreters.com/representing-code.html#visitors-for-expressions): The <R> at the very beginning declares a generic type
parameter for this specific method. It tells the Java compiler, "This method will work with some type that we will call R, but we don't know what R is right now.
The type R will be determined when the method is called."

### Error handling

* [On the location of the errors](https://craftinginterpreters.com/scanning.html#location-information): "Some token implementations store the location as two numbers: the offset from the beginning of
the source file to the beginning of the lexeme, and the length of the lexeme. The scanner needs to
know these anyway, so there’s no overhead to calculate them."

* [Reporting all errors](https://craftinginterpreters.com/scanning.html#lexical-errors): "Note also that we keep scanning. There may be other errors later in the program."

### Programming

* [static imports considered bad style](https://craftinginterpreters.com/scanning.html#the-scanner-class)
* [Ternary as a function argument](https://craftinginterpreters.com/scanning.html#operators): `addToken(match('=') ? BANG_EQUAL : BANG);`
* In Java, `finally` is used to execute code in a `try{}` block even if
  an exception is thrown. See [finally](https://craftinginterpreters.com/statements-and-state.html#assignment-syntax:~:text=void%20executeBlock(,%3D%20previous%3B%0A%20%20%20%20%7D%0A%20%20%7D))
