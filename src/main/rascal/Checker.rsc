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
data ScopeRole = functionScope()
              | loopScope();
str prettyAType(stringType()) = "string";
str prettyAType(numberType()) = "number";
str prettyAType(booleanType()) = "boolean";
str prettyAType(nullType()) = "null";
str prettyAType(objectType()) = "object";
str prettyAType(undefinedType()) = "undefined";
str prettyAType(voidType()) = "void";


// Collecting


//statements






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



void collect(current: (Exp) `<Exp exp1> = <Exp exp2>`, Collector c){
  c.use(exp1, {variableId()});
  c.requireEqual(exp1, exp2, error(current, "Lhs %t should have the same type as Rhs", exp1));
  collect(exp2, c);
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





void collect(current: (Function) `function <Id name> ( <{Id ","}* params> ) {  }`, Collector c){
  c.enterScope(current);
    c.define("<name>", variableId(), name, defType(voidType()));
    
    c.setScopeInfo(c.getScope(), functionScope(), functionInfo("<name>"));
    
  
  c.leaveScope(current);
}


data functionInfo = functionInfo(str name);
// Function
void collect(current: (Function) `function <Id name> ( <{Id ","}* params> ) { <Body body> }`, Collector c){
  c.enterScope(current);
    c.define("<name>", variableId(), name, defType(body));
    
    c.setScopeInfo(c.getScope(), functionScope(), functionInfo("<name>"));
  
    collect(body, c);
  c.leaveScope(current);
}

void collect(current: (Body) `<Statement* statement> <ReturnExp returnExp>`, Collector c){
  c.fact(current, returnExp);
  collect(statement, returnExp, c);
}
void collect(current: (Body) `<Statement* statement>`, Collector c){
  c.fact(current, voidType());
  collect(statement, c);
}
void collect(current: (Statement) `<Exp exp>`, Collector c){
  c.fact(current, exp);
  collect(exp, c);
}

void collect(current: (ReturnExp) `return <Exp exp>`, Collector c){
  c.fact(current, exp);
  collect(exp, c);
}
void collect(current: (Statement) `throw <Exp exp>`, Collector c){
  c.fact(current, exp);
  collect(exp, c);
}

//Loops
data LoopInfo = loopInfo(str name);

void collect(current: (Statement)`for ( <VariableStmt varStmt> ; <Exp exp1> ; <Exp exp2> ) { <Statement* statement> }`, Collector c){
  c.enterScope(current);
    loopName = "forLoop";
    c.setScopeInfo(c.getScope(), loopScope(), loopInfo(loopName));
  c.leaveScope(current);
}

void collect(current: (Statement)`for ( <VariableStmt varStmt> in <Exp exp>) { <Statement* statement> }`, Collector c){
  c.enterScope(current);
    loopName = "forLoop";
    c.setScopeInfo(c.getScope(), loopScope(), loopInfo(loopName));
  c.leaveScope(current);
}

void collect(current: (Statement)`while ( <Exp exp> ) { <Statement* statement> }`, Collector c){
  c.enterScope(current);
    loopName = "whileLoop";
    c.setScopeInfo(c.getScope(), loopScope(), loopInfo(loopName));
  c.leaveScope(current);
}

void collect(current: (Statement)`do { <Statement* statement> } while ( <Exp exp> )`, Collector c){
  c.enterScope(current);
    loopName = "whileLoop";
    c.setScopeInfo(c.getScope(), loopScope(), loopInfo(loopName));
  c.leaveScope(current);
}



// void collect(current:(Statement) `break <Exp exp>;`, Collector c){
//     loopName = "<exp>";
//     for(<scope, scopeInfo> <- c.getScopeInfo(loopScope())){       
//         if(loopInfo("whileLoop") := scopeInfo){
//             if(loopName == "" || loopName == "whileLoop"){
//                 collect(exp, c);
//                 return;
//              }
//         } else {
//             throw rascalCheckerInternalError(getLoc(current), "Inconsistent info from loop scope: <scopeInfo>");
//         }
//     }
//     c.report(error(current, "Break outside a while/do/for statement"));
// }

// conditionals
void collect(current:(Statement) `if ( <Exp cond> ) { <Body thenPart> }`, Collector c){
  c.calculate("if", current, [cond, thenPart],
  AType(Solver s){
    s.requireEqual(cond, booleanType(), error(current, "Condition should be of type `bool`, found %t", cond));
    return s.getType(thenPart);
  });
  collect(cond, thenPart, c);
}
void collect(current:(Statement) `if ( <Exp cond> ) { <Body thenPart> } else { <Body elsePart> }`, Collector c){
  c.calculate("ifelse", current, [cond, thenPart],
  AType(Solver s){
    s.requireEqual(cond, booleanType(), error(current, "Condition should be of type `bool`, found %t", cond));
    s.requireEqual(thenPart, elsePart, error(current, "thenPart and elsePart should have same type"));
    return s.getType(thenPart);
  });
  collect(cond, thenPart, elsePart, c);
}
