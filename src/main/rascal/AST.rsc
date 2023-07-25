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
data Function = function(str funcid, list[str] funcparams, list[Statement] funcBody);
data PropertyAssignment = propertyAssgn(str lhs, Exp rhs);
data Exp = 
            var(str id)
          | integer(int number)
          | string(str text)
          | array(list[Exp] arrayItems)
          | object(list[PropertyAssignment] objItems)
          | assign(Exp lhs, Exp rhs)
          ;
