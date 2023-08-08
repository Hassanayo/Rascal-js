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
          ;
data ScopeRole = functionScope();
str prettyAType(stringType()) = "string";
str prettyAType(numberType()) = "number";
str prettyAType(booleanType()) = "boolean";
str prettyAType(nullType()) = "null";
str prettyAType(objectType()) = "object";
str prettyAType(undefinedType()) = "undefined";
str prettyAType(voidType()) = "void";


// Collecting


//statements

void collect(current: (Statement) `<VariableStmt variableStmt>`, Collector c ){
  collect(variableStmt, c);
}


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






// overloadAddition
void overloadAddition(Exp current, str op, Exp exp1, Exp exp2, Collector c){
  c.calculate("Adding <op>", current, [exp1, exp2], 
    AType(Solver s) {
      t1 = s.getType(exp1);
      t2 = s.getType(exp2);

      switch([t1,t2]) {
        case [numberType(), numberType()]: return numberType();
        case [stringType(), stringType()]: return stringType();
        case [stringType(), numberType()]: return stringType();
        case [numberType(), stringType()]: return stringType();
        case [objectType(), objectType()]: return stringType();

        default: {
          s.report(error(current, "%q can not be defined on %t and %t", op, exp1, exp2));
          return voidType();
          }
      }
    });
    collect(exp1, exp2, c);
}

// overload function to operators except addition e.g *=, %=, -,/
void overloadCombinedOperator(Exp current, str op, Exp exp1, Exp exp2, Collector c){
  c.calculate("<op>", current, [exp1, exp2], 
    AType(Solver s) {
      t1 = s.getType(exp1);
      t2 = s.getType(exp2);

      switch([t1,t2]) {
        case [numberType(), numberType()]: return numberType();

        default: {
          s.report(error(current, "%q can not be defined on %t and %t", op, exp1, exp2));
          return voidType();
          }
      }
    });
    collect(exp1, exp2, c);
}

// overloadRelational to handle relational operators i.e booleans
void overloadRelational(Exp current, str op, Exp exp1, Exp exp2, Collector c){
  c.calculate("relational operator <op>", current, [exp1, exp2], 
    AType(Solver s) {
      t1 = s.getType(exp1);
      t2 = s.getType(exp2);
      switch([t1, t2]) {
        case [numberType(), numberType()]: return booleanType();
        case [stringType(), stringType()]: return booleanType();
        case [booleanType(), booleanType()]: return booleanType();
        case [nullType(), nullType()]: return booleanType();
        case [undefinedType(), undefinedType()]: return booleanType();
        case [objectType(), objectType()]: return booleanType();
        default: {
          s.report(error(current, "%q cannot be used on %t and %t", op, exp1, exp2));
          return voidType();
        }
      }
    }
    );
    collect(exp1, exp2, c);
}



// wrong: dont use overloadRelational for =
void collect(current: (Exp) `<Exp exp1> = <Exp exp2>`, Collector c)
    = overloadRelational(current, "=", exp1, exp2, c);




void collect(current: (Exp) `<Exp exp1> + <Exp exp2>`, Collector c)
    = overloadAddition(current, "+", exp1, exp2, c);
void collect(current: (Exp) `<Exp exp1> += <Exp exp2>`, Collector c)
    = overloadAddition(current, "+=", exp1, exp2, c);

void collect(current: (Exp) `<Exp exp1> != <Exp exp2>`, Collector c)
    = overloadRelational(current, "!=", exp1, exp2, c);

void collect(current: (Exp) `<Exp exp1> == <Exp exp2>`, Collector c)
    = overloadRelational(current, "==", exp1, exp2, c);

void collect(current: (Exp) `<Exp exp1> === <Exp exp2>`, Collector c)
    = overloadRelational(current, "===", exp1, exp2, c);

void collect(current: (Exp) `<Exp exp1> !== <Exp exp2>`, Collector c)
    = overloadRelational(current, "!==", exp1, exp2, c);

void collect(current: (Exp) `<Exp exp1> \> <Exp exp2>`, Collector c)
    = overloadRelational(current, "\>", exp1, exp2, c);

void collect(current: (Exp) `<Exp exp1> \< <Exp exp2>`, Collector c)
    = overloadRelational(current, "\<", exp1, exp2, c);

void collect(current: (Exp) `<Exp exp1> \>= <Exp exp2>`, Collector c)
    = overloadRelational(current, "\>=", exp1, exp2, c);

void collect(current: (Exp) `<Exp exp1> \<= <Exp exp2>`, Collector c)
    = overloadRelational(current, "\<=", exp1, exp2, c);



void collect(current: (Exp) `<Exp exp1> - <Exp exp2>`, Collector c)
    = overloadCombinedOperator(current, "-", exp1, exp2, c);
void collect(current: (Exp) `<Exp exp1> -= <Exp exp2>`, Collector c)
    = overloadCombinedOperator(current, "-=", exp1, exp2, c);

void collect(current: (Exp) `<Exp exp1> * <Exp exp2>`, Collector c)
    = overloadCombinedOperator(current, "*", exp1, exp2, c);
void collect(current: (Exp) `<Exp exp1> *= <Exp exp2>`, Collector c)
    = overloadCombinedOperator(current, "*=", exp1, exp2, c);

void collect(current: (Exp) `<Exp exp1> / <Exp exp2>`, Collector c)
    = overloadCombinedOperator(current, "/", exp1, exp2, c);
void collect(current: (Exp) `<Exp exp1> /= <Exp exp2>`, Collector c)
    = overloadCombinedOperator(current, "/=", exp1, exp2, c);

void collect(current: (Exp) `<Exp exp1> % <Exp exp2>`, Collector c)
    = overloadCombinedOperator(current, "%", exp1, exp2, c);
void collect(current: (Exp) `<Exp exp1> %= <Exp exp2>`, Collector c)
    = overloadCombinedOperator(current, "%=", exp1, exp2, c);

void collect(current: (VariableStmt) `var <{VariableDecl ","}+ variableDecl>`, Collector c){
  collect(variableDecl, c);
}

data functionInfo = functionInfo(str name);
// Function
void collect(current: (Function) `function <Id name> ( <{Id ","}* params> ) { <Statement* statement> }`, Collector c){
  c.enterScope(current);
    c.define("<name>", variableId(), name, defType(statement));
    
    c.setScopeInfo(c.getScope(), functionScope(), functionInfo("<name>"));
    for(stm <- statement){
      c.calculate("function", current, [stm], 
      AType(Solver s){
        t1 = s.getType(stm);
        switch([t1]){
          case [numberType()]: return numberType();
          case [stringType()]: return stringType();
          case [objectType()]: return objectType();
          case [booleanType()]: return booleanType();
          case [nullType()]: return nullType();
          case []: return voidType();

        default: {
          s.report(error(current, "%t", stm));
          return voidType();
          }
        }
    });

    };
    
    collect(statement, c);
  c.leaveScope(current);
}


