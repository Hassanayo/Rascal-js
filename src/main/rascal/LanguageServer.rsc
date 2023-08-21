module LanguageServer

import ParseTree;

import util::Reflective;
import util::LanguageServer;
import JSSyntax;
import Implode;
import Prelude;

import compile::Js2Py;

set[LanguageService] syntaxContributions() = {
  parser(parser(#start[Source]))
  , lenses(sourceLenses)
  , executor(hqlCommandHandler)
};

data Command = translateToPython(start[Source] input);

rel[loc, Command] sourceLenses(start[Source] input)
  = {
    <input@\loc, translateToPython(input, title="Translate to Python")>
  };




public void generatePython(start[Source] pt, loc l){
  for (<name, class> <- js2py(implode(pt.top))) {
		writeFile(|project://rascal-js/output/<name>.py|, class);
	}
}

value hqlCommandHandler(translateToPython(start[Source] input)){
  generatePython(input, input@\loc);
  return ("result" : true);
}

void setupIDE(){
  registerLanguage(
    language(
      pathConfig(srcs = [|std:///|, |project://rascal-js/src/main/rascal|]),
       "Javasct",
       "jap",
       "LanguageServer",
       "syntaxContributions"
    )
  );
}