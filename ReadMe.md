This GitHub repository contains two modules: AST and JSSyntax, which are used for working with Abstract Syntax Trees (ASTs) and parsing JavaScript (JS) syntax, respectively. The repository is meant to help with the manipulation of JavaScript code through AST representations and lexical analysis.

Module: AST
The AST module provides a data structure and algebraic data types (ADTs) to represent JavaScript Abstract Syntax Trees. It includes the following ADTs:

Stmt
varstatement(VariableStmt varStmt): Represents a variable statement.
Decl
vardeclaration(VariableDecl varDecl): Represents a variable declaration.
VariableStmt
variableStatement(list[VariableDecl] vdecl, list[str] scolon): Represents a collection of variable declarations with optional semicolons.
VariableDecl
variableDeclaration(str id, list[Initialize] init): Represents a variable declaration with an identifier and optional initializer.
Initialize
initialize(Exp exp): Represents the initializer expression for a variable declaration.
Exp
var(str id): Represents a variable reference.
integer(int number): Represents an integer literal.
string(str text): Represents a string literal.
mult(Exp lhs, Exp rhs): Represents a multiplication operation between two expressions.
add(Exp lhs, Exp rhs): Represents an addition operation between two expressions.
Module: JSSyntax
The JSSyntax module extends the JSLex module, providing lexical analysis for JavaScript syntax. It includes the following lexical definitions:

Lexical Definitions
Id: Represents an identifier, starting with a letter and followed by letters or numbers. It must not be followed by another character and must not be a reserved keyword.
Integer: Represents an integer literal.
String: Represents a string literal enclosed within double quotes.
Let, Const, Var: Represents reserved keywords for variable declarations.
SemiColon: Represents the semicolon symbol.
Boolean: Represents the boolean literals "true" or "false".
NewLine: Represents newline characters.
Null: Represents the null literal.
Declarator: Represents the keywords "let", "const", or "var".
ReservedKeywords: Represents a list of reserved keywords in JavaScript.
Syntax Definitions
The JSSyntax module defines the syntax for parsing JavaScript code. It includes the following syntax definitions:

Source: Represents a JavaScript source file, starting with a varstatement.
Statement: Represents various types of JavaScript statements, such as variable declarations, blocks, functions, if-else statements, and for loops.
VariableStmt: Represents a statement containing multiple variable declarations.
VariableDecl: Represents a single variable declaration with an optional initializer.
Initialize: Represents the initialization expression for a variable declaration.
Function: Represents a JavaScript function definition.
Exp: Represents JavaScript expressions, including variable references, literals, and binary operations.