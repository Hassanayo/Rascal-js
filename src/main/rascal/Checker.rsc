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


void collect(current: (VariableStmt) `<Declarator declarator> <VariableDecl variableDecl>`, Collector c){
  collect(declarator, variableDecl, c);
}

