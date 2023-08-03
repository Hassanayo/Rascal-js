module Test

import Checker;
extend analysis::typepal::TestFramework;
import Parse;
import JSSyntax;


TModel calcTModelFromTree(Tree pt){
    return collectAndSolve(pt);
}

TModel calcTModelFromStr(str text){
    pt = parse(#start[Source], text).top;
    return calcTModelFromTree(pt);
}
