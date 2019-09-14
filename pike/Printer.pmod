import .Types;

string pr_str(Val ast, bool print_readably)
{
  if(functionp(ast)) return "#<fn>";
  return ast->to_string(print_readably);
}
