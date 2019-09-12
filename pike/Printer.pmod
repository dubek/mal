import .Types;

string pr_str(Val ast, bool print_readably)
{
  return ast->to_string(print_readably);
}
