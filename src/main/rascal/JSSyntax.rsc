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

    // control statements
    | forLoop: "for" "(" VariableStmt init ";" Exp cond ";" Exp cond ")" "{" Body "}" forBody
    | forIn: "for" "(" VariableStmt "in" Exp ")" "{" Body "}"
    | whileLoop: "while" "(" Exp ")" "{" Body "}" 
    | doWhile: "do" "{" Body "}" "while" "(" Exp ")"
    | ifThen: "if" "(" Exp cond ")" "{" Body "}"  () !>> "else"
    | ifElse: "if" "(" Exp cond ")" "{" Body "}"  () "else" "{" Body "}" elseBody
    | switchCase: "switch" "(" Exp ")" "{" CaseStatement* "}"
    
    | tryCatch: "try" "{" Body "}" "catch" "(" Id ")" "{" Body "}"
    | tryFinally: "try" "{" Body "}" "finally" "{" Body "}"
    | tryCatchFinally: "try" "{" Body "}" "catch" "(" Id ")" "{" Body "}" catchBody "finally" "{" Body "}" finallyBody

    // | returnExp: "return" Exp
    | throwExp: "throw" Exp
    | breakLabel: "break" ";"
    | breakLabelExp: "break" Exp";"
    | continueLabel: "continue" ";"

    ;
syntax VariableStmt = variableStatement: Declarator {VariableDecl ","}+ ;
syntax VariableDecl = varDeclaration: Id Initialize?;
syntax Initialize = initialize: "=" Exp;


// add an optional return stmt
syntax Function = 
                function: "function" Id name "(" {Id ","}* parameters ")" "{" Body "}"
                // | Declarator Id name "=" "(" {Id ","}* parameters ")" "=\>" "{" Statement* statements  "}"  "(" {Id ","}* parameters ")" "{" Statement* statements "}"
                ;


syntax Body = body: Statement* statement ReturnExp?;

syntax ReturnExp = returnExp: "return" Exp;
syntax PropertyAssignment = propertyAssgn: Exp ":" Exp;
syntax CaseStatement = caseOf: "case" Exp ":" Statement*
                    |  defaultCase: "default" ":" Statement*;
syntax Exp
              = var: Id
              | integer: Integer
              | string: String
              | boolean: Boolean
              | bracket "(" Exp ")"
              | null: Null
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
                | neqq: Exp lhs "!==" Exp rhs
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
