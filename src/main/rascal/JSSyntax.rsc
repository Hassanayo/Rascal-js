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
    | forLoop: "for" "(" VariableStmt init ";" Exp cond ";" Exp cond ")" "{" Statement* "}" forBody
    | forIn: "for" "(" VariableStmt "in" Exp ")" "{" Statement* "}"
    | whileLoop: "while" "(" Exp ")" "{" Statement* "}" 
    | doWhile: "do" "{" Statement* "}" "while" "(" Exp ")"
    | ifThen: "if" "(" Exp cond ")" "{" Statement "}"  () !>> "else"
    | ifElse: "if" "(" Exp cond ")" "{" Statement "}"  () "else" "{" Statement* "}" elseBody
    | switchCase: "switch" "(" Exp ")" "{" CaseStatement* "}"
    
    | tryCatch: "try" "{" Statement* "}" "catch" "(" Id ")" "{" Statement* "}"
    | tryFinally: "try" "{" Statement* "}" "finally" "{" Statement* "}"

    // ambiguity issue
    | tryCatchFinally: "try" "{" Statement* "}" "catch" "(" Id ")" "{" Statement* "}" catchBody "finally"  Statement*  finallyBody

    | returnExp: "return" Exp
    | throwExp: "throw" Exp
    | breakLabel: "break" ";"
    | continueLabel: "continue" ";"

    ;
syntax NewStmt = "ayo" Id "-=" "5";
syntax VariableStmt = variableStatement: Declarator {VariableDecl ","}+ ;
syntax VariableDecl = varDeclaration: Id Initialize?;
syntax Initialize = initialize: "=" Exp;

syntax Function = 
                function: "function" Id name "(" {Id ","}* parameters ")" "{" Statement* statements "}"
                // | Declarator Id name "=" "(" {Id ","}* parameters ")" "=\>" "{" Statement* statements  "}"  "(" {Id ","}* parameters ")" "{" Statement* statements "}"
                ;

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
