module AST

import JSSyntax;


data Source = source(list[Statement] statements);


data Statement = varStmt(VariableStmt varSmt)
                | expression(Exp newexp)
                | function(Function function)
                | ifThen(Exp exp, Statement ifstmt)
                | ifElse(Exp exp, Statement ifstmt, list[Statement] elsestmt)
                | forLoop(VariableStmt stmt, Exp midexp, Exp lastexp, list[Statement] forbody)
                | forIn(VariableStmt stmt, Exp exp, list[Statement] forinstmt )
                | returnExp(Exp retExp)
                | throwExp(Exp thrwExp)
                ;
                
data VariableStmt = variableStatement(str declarator, list[VariableDecl] vdecl);
data VariableDecl = varDeclaration(str id, list[Initialize] init);
data Initialize = initialize(Exp intexp);
data Function = function(str funcid, list[str] funcparams, list[Statement] funcBody);
data PropertyAssignment = propertyAssgn(str lhs, Exp rhs);
data Exp = 
            var(str id)
          | integer(int number)
          | string(str text)
          | array(list[Exp] arrayItems)
          | object(list[PropertyAssignment] objItems)
          | assign(Exp lhs, Exp rhs)
          | postIncr(Exp exp)
          | postDecr(Exp exp)
          | preIncr(Exp exp)
          | preDecr(Exp exp)
          | not(Exp exp)
          | mul(Exp nlhs, Exp nrhs)
          | div(Exp nlhs, Exp nrhs)
          | rem(Exp nlhs, Exp nrhs)
          | add(Exp nlhs, Exp nrhs)
          | sub(Exp nlhs, Exp nrhs)
          | lt(Exp nlhs, Exp nrhs)
          | gt(Exp nlhs, Exp nrhs)
          | leq(Exp nlhs, Exp nrhs)
          | geq(Exp nlhs, Exp nrhs)
          | eqq(Exp nlhs, Exp nrhs)
          | neqq(Exp nlhs, Exp nrhs)
          | eq(Exp nlhs, Exp nrhs)
          | neq(Exp nlhs, Exp nrhs)
          ;
