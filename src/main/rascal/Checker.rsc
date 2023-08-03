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

str prettyAType(stringType()) = "string";
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


void collect(current: (VariableDecl) `<Id id> = <Exp exp>`, Collector c){
  c.define("<id>", variableId(), id, defType(exp));
  collect(exp, c);
}

void collect(current: (VariableDecl) `<Id id>`, Collector c){
  c.define("<id>", variableId(), id, defType(stringType()));
}
// void collect(current: (Initialize) `= <Exp exp>`, Collector c){
//   c.define("<exp>", variableId(), exp, defType(exp));
//   collect(exp, c);
  
// }

void collect(current: (Exp) `<Id name>`, Collector c){
  c.use(name, {variableId()});
}

// check Exp
void collect(current: (Exp) `<Integer number>`,  Collector c){
  c.fact(current, numberType());
}

void collect(current: (Exp) `<Boolean boolean>`,  Collector c){
  c.fact(current, booleanType());
}
void collect(current: (Exp) `<String number>`,  Collector c){
  c.fact(current, stringType());
}
void collect(current: (Exp) `<Null null>`,  Collector c){
  c.fact(current, nullType());
}
// void collect(current: (Exp) `<Object object>`,  Collector c){
//   c.fact(current, objectType());
// }