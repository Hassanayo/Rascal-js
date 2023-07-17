module TSLex

extend lang::std::Layout;

//Must start with a letter followed by letters or numbers and must not be followed by another character. Also must not be a keyword
lexical Id = ([a-z A-Z][a-z A-Z 0-9]* !>> [a-z A-Z 0-9]) \ Keyword;

lexical Integer = [0-9] !<< [0-9]+ !>> [0-9];

// a string is a charavter between double quotes
lexical String = [\"] StringChar* [\"];
lexical StringChar = ![\\ \" \n] | "\\" [\\ \"];
lexical Let = "let";
lexical Const = "const";
lexical SemiColon = ";";
lexical Boolean = "true" | "false";
lexical NewLine = "\r\n" | "\r\t";

keyword Reserved
                = "true"
                | "false"
                | "null"
                | "return"
                | "let"
                | "const"
                | "var"
                | "break"
                | "case"
                | "switch"
                | "catch"
                | "continue"
                | "default"
                | "if"
                | "else"
                | "for"
                | "in"
                | "new"
                | "try"
                | "catch"                
                ;

