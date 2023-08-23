module compile::Js2Py

import AST;
import String;

public rel[str, str] js2py(Source es){
  return { <"output", initiate(e)> | e <- es.statements };
}


// use comprehensions for the problem
// int countAssignments(PROGRAM P){
//     int n = 0;
//     visit (P){
//     case asgStat(_, _):
//          n += 1;
//     }
//     return n;
// }
public str initiate(Statement e){
  switch(e) {
        case varStmt(VariableStmt varSmt): return statement2Declaration(varSmt);
        case function(Function function): return statement2Function(function);

        default: return "";
      }
}


// variable declaration
public str statement2Declaration(VariableStmt es){
  return "<for(f <- es.vdecl){><f.id> = <init2Exp(f.init)><}>"; 
}

public str init2Exp(list[Initialize] es){
  return "<for(f <- es){><exp2Python(f.intexp)><}>";
}


// functions
public str statement2Function(Function e){
  return "def <e.funcid>(<funcParameters(e.funcparams)>):
              <body2py(e.funcBody)>";
}


public str body2py(Body e){
  return "<for (f <- e.statements){>
          '  <statement2Declaration(f.varSmt)><}>
          <for (f <- e.returnExp){>
          '  return <exp2Python(f.exp)><}>";
}



public str funcParameters(list[str] params){
  newstr = "";
  for(e <- params){
    newstr = newstr + e;
  };
  return newstr;
}

// Exp
public str exp2Python(var(str id)) = "<id>";
public str exp2Python(integer(int number)) = "<number>";
public str exp2Python(string(str text)) = "<text>";
public str exp2Python(boolean(bool b)) = capitalize("<b>");
public str exp2Python(null(str n)) = "<n>";
public str exp2Python(add(Exp l, Exp r)) = "<exp2Python(l)> + <exp2Python(r)>";
public str exp2Python(sub(Exp l, Exp r)) = "<exp2Python(l)> - <exp2Python(r)>";
public str exp2Python(mul(Exp l, Exp r)) = "<exp2Python(l)> * <exp2Python(r)>";
public str exp2Python(div(Exp l, Exp r)) = "<exp2Python(l)> / <exp2Python(r)>";
public str exp2Python(\bracket(Exp exp)) = "<exp2Python(exp)>";

public str capitalize(str s) {
  return toUpperCase(substring(s, 0, 1)) + substring(s, 1);
}
