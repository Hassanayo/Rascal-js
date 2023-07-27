# Rebuilding Javascript With Rascal MPL

This GitHub repository contains files needed to build the javascript language using Rascal MPL.

## Module: AST

The `AST` module provides a data structure and algebraic data types (ADTs) to represent JavaScript Abstract Syntax Trees.

## Module: JSSyntax

This module represents the syntax of the javascript language and these are the rules that describe the correctly structured programs in the javascript

## Module: JSLex

This module is the initial phase of the language processing pipeline which are the smallest units of the language and breaks the source code into individual tokens which is then passed/extended to the syntax.


## Module: Parse

Parse a javascript program from a string or file. It uses the syntax rules provided to parse a string and turn it into a parse tree. It uses the `parse` function provided by Rascal


## Module: Load

This module is used to parse the given string or file and convert it into an abstract syntax tree. It uses the `implode` function provided by Rascal to transform parse trees to abstract syntax trees