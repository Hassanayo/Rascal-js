module utils::Load

import JSSyntax;
import AST;
import Parse;
import ParseTree;

Source load(loc l) = implode(#Source, parse(l));
Source load(str s) = implode(#Source, parse(s));