module LanguageServer

import ParseTree;

import util::Reflective;
import util::LanguageServer;
import JSSyntax;
import utils::Implode;
import Prelude;
import utils::Test;

import compile::Js2Py;

set[LanguageService] syntaxContributions() = {
  parser(parser(#start[Source]))
  , summarizer(aliasesSummarizer,  providesImplementations = false)
  , lenses(sourceLenses)
  , executor(hqlCommandHandler)
};

Summary aliasesSummarizer(loc l, start[Source] input) {
  pt = parse(#start[Source], l).top;
  TModel model = calcTModelFromTree(input);
  definitions = model.definitions; 
  return summary(l,
      messages = {<message.at, message> | message <- model.messages},
      references = {<definition, definitions[definition].defined> | definition <- definitions}
);}

data Command = translateToPython(start[Source] input);

rel[loc, Command] sourceLenses(start[Source] input)
  = {
    <input@\loc, translateToPython(input, title="Translate to Python")>
  };


public void generatePython(start[Source] pt){
  for (<name, class> <- js2py(implode(pt.top))) {
		writeFile(|project://rascal-js/output/<name>.py|, class);
	}
}

value hqlCommandHandler(translateToPython(start[Source] input)){
  generatePython(input);
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