module compile::Js2Py

import AST;


public rel[str, str] js2py(Source es){
  return { <e.function.funcid, statement2Function(e.function)> | e <- es.statements };
}

public str statement2Function(Function e){
  return "def <e.funcid> (<funcParameters(e.funcparams)>):";
}

public str funcParameters(list[str] params){
  newstr = "";
  for(e <- params){
    newstr = newstr + e;
  };
  return newstr;
}