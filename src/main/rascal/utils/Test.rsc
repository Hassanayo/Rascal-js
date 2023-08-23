module utils::Test

import checker::Checker;
extend analysis::typepal::TestFramework;
import utils::Parse;
import JSSyntax;


TModel calcTModelFromTree(Tree pt){
    return collectAndSolve(pt);
}

TModel calcTModelFromStr(str text){
    pt = parse(#start[Source], text).top;
    return calcTModelFromTree(pt);
}
TModel calcTModelFromStr(loc text){
    pt = parse(#start[Source], text).top;
    return calcTModelFromTree(pt);
}
