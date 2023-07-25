module JSSyntax

extend JSLex;
start syntax Source
    = source: Statement* 
    ;
syntax Statement 
    = varStmt: VariableStmt 
    | block: "{" Statement* "}"
    | expression: Exp!function expression
    | function: Function function
    | ifThen: "if" "(" Exp cond ")" Statement body () !>> "else"
    | ifElse: "if" "(" Exp cond ")" Statement body () "else" Statement elseBody
    | forLoop: "for" "(" VariableStmt init ";" Exp cond ";" Exp cond ")" Statement forBody
    | forIn: "for" "(" VariableStmt "in" Exp ")" Statement
    | returnExp: "return" Exp
    | throwExp: "throw" Exp
    ;

syntax VariableStmt = variableStatement: Declarator {VariableDecl ","}+ ;
syntax VariableDecl = varDeclaration: Id Initialize?;
syntax Initialize = initialize: "=" Exp;

syntax Function = 
                function: "function" Id name "(" {Id ","}* parameters ")" "{" Statement* statements "}"
                // | Declarator Id name "=" "(" {Id ","}* parameters ")" "=\>" "{" Statement* statements  "}"  "(" {Id ","}* parameters ")" "{" Statement* statements "}"
                ;

syntax PropertyAssignment =propertyAssgn: Exp ":" Exp;
start syntax Exp
              = var: Id
              | integer: Integer
              | string: String
              | array: "[" {Exp ","}* "]"
              | object: "{" {PropertyAssignment ","}* "}"
              > postIncr: Exp "++"
              | postDecr: Exp "--"
              > preIncr: "++" Exp
              | preDecr: "--" Exp
              | not: "!" Exp
              > left (
                    mul: Exp lhs "*" Exp rhs
                  | div: Exp lhs "/" Exp rhs
                  | rem: Exp lhs "%" Exp rhs
              )
              > left (
                    add: Exp lhs "+" Exp rhs
                  | sub: Exp lhs "-" Exp rhs 
              )
              > non-assoc (
                  lt: Exp lhs "\<" Exp rhs
                | gt: Exp lhs "\>" Exp rhs
                | leq: Exp lhs "\<=" Exp rhs
                | geq: Exp lhs "\>=" Exp rhs
              )
              > right (
                  eqq: Exp lhs "===" Exp rhs
                | neqq: Exp lhs "!===" Exp rhs
                | eq: Exp lhs "==" Exp rhs
                | neq: Exp lhs "!=" Exp rhs
              )
              > right (
                  assign: Exp lhs "=" Exp rhs
                | assignMul: Exp lhs "*=" Exp rhs
                | assignDiv: Exp lhs "/=" Exp rhs
                | assignRem: Exp lhs "%=" Exp rhs
                | assignAdd: Exp lhs "+=" Exp rhs
                | assignSub: Exp lhs "-=" Exp rhs
              )
              ;
