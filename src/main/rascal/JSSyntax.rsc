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
    | returnExp: "return" Exp SemiColon?
    | ifThen: "if" "(" Exp cond ")" Statement body () !>> "else"
    | ifElse: "if" "(" Exp cond ")" Statement body () "else" Statement elseBody
    | forLoop: "for" "(" VariableStmt init ";" Exp cond ";" Exp cond ")" Statement forBody
    ;

syntax VariableStmt = variableStatement: Declarator? {VariableDecl ","}+ SemiColon?;
syntax VariableDecl = varDeclaration: Id Initialize?;
syntax Initialize = initialize: "=" Exp;

syntax Function = 
                function: "function" Id name "(" {Id ","}* parameters ")" "{" Statement* statements "}"
                | Declarator Id name "=" "(" {Id ","}* parameters ")" "=\>" "{" Statement* statements  "}"
                ;

start syntax Exp
              = var: Id
              | integer: Integer
              | string: String
              | left assgn: Exp "=" Exp
              > left mult: Exp "*" Exp
              > left add: Exp "+" Exp
              ;
