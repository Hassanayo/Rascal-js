module AST

import JSSyntax;


data Source = source(list[Statement] statements);

data Statement = varStmt(VariableStmt varSmt)
                | expression(Exp newexp)
                | function(Function function)
                | returnExp(Exp retExp)
                | throwExp(Exp thrwExp)
                ;
                
data VariableStmt = variableStatement(str declarator, list[VariableDecl] vdecl);
data VariableDecl = varDeclaration(str id, list[Initialize] init);
data Initialize = initialize(Exp intexp);

data Exp = 
            var(str id)
          | integer(int number)
          | string(str text)
          | assign(Exp lhs, Exp rhs)
          ;
