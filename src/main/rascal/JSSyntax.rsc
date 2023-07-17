module JSSyntax

extend JSLex;

start syntax Source = varstatement: Statement;


start syntax Source
    = source: Statement statements
    ;
syntax Statement 
    = varDecl: VariableStmt
    | block: "{" Statement* "}"
    | function: Function function
    ;

syntax VariableStmt = variableStatement: Declarator {VariableDecl ","}+ SemiColon?;
syntax VariableDecl = varDeclaration: Id Initialize?;
syntax Initialize = initialize: "=" Exp;

syntax Function = "function" Id name "(" {Id ","}* parameters ")" "{" Statement* statements "}";

start syntax Exp
              = var: Id
              | integer: Integer
              | string: String
              > left mult: Exp "*" Exp
              > left add: Exp "+" Exp
              ;
