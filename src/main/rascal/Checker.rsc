module Checker

import JSSyntax;
extend analysis::typepal::TypePal;


data AType 
          = stringType()
          | numberType()
          | booleanType()
          | nullType()
          | objectType()
          | undefinedType()
          ;

str prettyAType(string()) = "string";
str prettyAType(numberType()) = "number";
str prettyAType(booleanType()) = "boolean";
str prettyAType(nullType()) = "null";
str prettyAType(objectType()) = "object";
str prettyAType(undefinedType()) = "undefined";


// Collecting
void collect(current: (VariableStmt) `var <{VariableDecl ","}+ variableDecl>`, Collector c){
  collect(variableDecl, c);
}
void collect(current: (VariableStmt) `let <{VariableDecl ","}+ variableDecl>`, Collector c){
  collect(variableDecl, c);
}
void collect(current: (VariableStmt) `const <{VariableDecl ","}+ variableDecl>`, Collector c){
  collect(variableDecl, c);
}

void collect(current: (VariableDecl) `<Id id> <Initialize initialize>`, Collector c){
  c.define("<id>", variableId(), id, defType(initialize));
  collect(initialize, c);
}
void collect(current: (Initialize) `= <Exp exp>`, Collector c){
  c.define("<exp>", expId(), exp, numberType());
}

