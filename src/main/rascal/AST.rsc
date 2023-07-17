module AST

import JSSyntax;

data Stmt = varstatement(VariableStmt varStmt);

data Decl = vardeclaration(VariableDecl varDecl);

data VariableStmt = variableStatement(list[VariableDecl] vdecl, list[str] scolon);

data VariableDecl = variableDeclaration(str id, list[Initialize] init);

data Initialize = initialize(Exp exp);

data Exp = var(str id)
         | integer(int number)
         | string(str text)
         | mult(Exp lhs, Exp rhs)
         | add(Exp lhs, Exp rhs)
         ;