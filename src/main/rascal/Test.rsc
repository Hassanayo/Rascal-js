module Test

import Checker;
extend analysis::typepal::TestFramework;
import ParseTree;

TModel calcTModelFromStr(str text){
    pt = parse(#start[Calc], text).top;
    return calcTModelFromTree(pt);
}
