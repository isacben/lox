#jlox Interpreter

This is the implementation of the jlox interpreter from the book [Crafting Interpreters](https://craftinginterpreters.com/).

This README is mainly to take notes while I read the book.

### Compilers in general

* [Reference to computer science text book](https://craftinginterpreters.com/scanning.html#regular-languages-and-expressions): the [dragon book](https://en.wikipedia.org/wiki/Compilers:_Principles,_Techniques,_and_Tools)

### Lexing

* [Handling longer lexems and lookahead](https://craftinginterpreters.com/scanning.html#longer-lexemes)

### Error handling

* [On the location of the errors](https://craftinginterpreters.com/scanning.html#location-information): "Some token implementations store the location as two numbers: the offset from the beginning of
the source file to the beginning of the lexeme, and the length of the lexeme. The scanner needs to
know these anyway, so there’s no overhead to calculate them."

* [Reporting all errors](https://craftinginterpreters.com/scanning.html#lexical-errors): "Note also that we keep scanning. There may be other errors later in the program."

### Programming

* [static imports considered bad style](https://craftinginterpreters.com/scanning.html#the-scanner-class)
* [Ternary as a function argument](https://craftinginterpreters.com/scanning.html#operators): `addToken(match('=') ? BANG_EQUAL : BANG);`
