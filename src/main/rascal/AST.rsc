module AST

import JSSyntax;


data Source = source(Statement statement);

data Statement = varDecl(VariableDecl varDecl)
                // | function(Function function)
                // | returnExp(Exp retExp)
                // | throwExp(Exp thrwExp)
                ;
data VariableStmt = variableStatement(list[VariableDecl] vdecl, list[str] scolon);
data VariableDecl = varDeclaration(str id, list[Initialize] init);
data Initialize = initialize(Exp initexp);

data Exp = 
            var(str id)
          | integer(int number)
          | string(str text)
          ;
