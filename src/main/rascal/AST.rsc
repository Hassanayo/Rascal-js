module AST

import JSSyntax;


data Source = source(list[Statement] statements);


data Statement =
                //  varStmt(VariableStmt varSmt)
                // | expression(Exp newexp)
                // | block(list[Statement] blockStmt)
                 function(Function function)

                // control statements
                // | forLoop(VariableStmt stmt, Exp midexp, Exp lastexp, Body forbody)
                // | forIn(VariableStmt stmt, Exp exp, Body forinstmt )
                // | whileLoop(Exp exp, Body whilebody)
                // | doWhile(Body doStmt, Exp exp)
                // | ifThen(Exp exp, Statement ifstmt)
                // | ifElse(Exp exp, Statement ifstmt, Body elsestmt)
                // | switchCase(Exp exp, list[CaseStatement] caseStmt)

                // | tryCatch(Body tryStmt, str id, Body catchStmt)
                // | tryFinally(Body tryStmt, Body finallyStmt)
                // | tryCatchFinally(Body tryStmt, str id, Body catchStmt, Body finallyStmt)

                
                // | breakLabel()
                // | continueLabel()
                // // | returnExp(Exp retExp)
                // | throwExp(Exp thrwExp)
                ;
                
data VariableStmt = variableStatement(str declarator, list[VariableDecl] vdecl);
data VariableDecl = varDeclaration(str id, list[Initialize] init);
data Initialize = initialize(Exp intexp);
data Function = function(str funcid, list[str] funcparams, Body funcBody);
data Body = body(list[Statement] statements, list[ReturnExp] returnExp);
data ReturnExp = returnExp(Exp exp);
data PropertyAssignment = propertyAssgn(str lhs, Exp rhs);
data CaseStatement =  
                      caseOf(Exp exp, list[Statement] caseBody)
                    | defaultCase(list[Statement] caseBody)
                    ;

data Exp = 
            var(str id)
          | integer(int number)
          | string(str text)
          | boolean(bool b)
          | null(str n)
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
