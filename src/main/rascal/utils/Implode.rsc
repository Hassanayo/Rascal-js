module utils::Implode

import JSSyntax;
import AST;
import ParseTree;

public AST::Source implode(JSSyntax::Source pt){
  return implode(#AST::Source, pt);
}