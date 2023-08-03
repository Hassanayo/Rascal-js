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
          | voidType()
          | NaNType()
          ;

str prettyAType(stringType()) = "string";
str prettyAType(numberType()) = "number";
str prettyAType(booleanType()) = "boolean";
str prettyAType(nullType()) = "null";
str prettyAType(objectType()) = "object";
str prettyAType(undefinedType()) = "undefined";
str prettyAType(voidType()) = "void";
str prettyAType(NaNType()) = "NaN";


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

// Parenthesis
void collect(current: (Exp) `( <Exp e> )`, Collector c){
  c.fact(current, e);
  collect(e, c);
}

// check if variable exists
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


// overloadAdding to handle multiple operators at once
// void overloadAdding(Exp current, str op, Exp exp1, Exp exp2, Collector c){
//   c.calculate("<op>", current, [exp1, exp2], 
//     AType(Solver s) {
//       t1 = s.getType(exp1);
//       t2 = s.getType(exp2);

//       switch([t1,t2]) {
//         case [numberType(), numberType()]: return numberType();
//         case [stringType(), stringType()]: return stringType();
//         case [stringType(), numberType()]: return NaNType();
//         case [numberType(), stringType()]: return NaNType();

//         default: {
//           s.report(error(current, "%q can not be defined on %t and %t", op, exp1, exp2));
//           return voidType();
//           }
//       }
//     });
//     collect(exp1, exp2, c);
// }

// Check Addition
void collect(current: (Exp) `<Exp exp1> + <Exp exp2>`, Collector c){
  c.calculate("addition", current, [exp1, exp2],
    AType(Solver s){
      t1 = s.getType(exp1);
      t2 = s.getType(exp2);

      switch([t1,t2]) {
        case [numberType(), numberType()]: return numberType();
        case [stringType(), stringType()]: return stringType();
        case [stringType(), numberType()]: return stringType();
        case [numberType(), stringType()]: return stringType();

        default: {
          s.report(error(current, "%q can not be defined on %t and %t", exp1, exp2));
          return voidType();
          }
      }
    }
  );
  collect(exp1, exp2, c);
}