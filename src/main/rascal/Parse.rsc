module Parse

import JSSyntax;
import ParseTree;

Source parse(loc l) = parse(#Source, l);
Source parse(str s) = parse(#Source, s);