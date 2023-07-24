module Load

import JSSyntax;
import AST;
import Parse;
import ParseTree;

Source load(loc l) = implode(parse(l));
Source load(str s) = implode(parse(s));
