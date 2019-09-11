import .Printer;
import .Reader;
import .Readline;
import .Types;

Val READ(string str)
{
  return read_str(str);
}

Val eval_ast(Val ast, mapping(string:function) env)
{
  switch(ast.type())
  {
    case "Symbol":
      function f = env[ast.value];
      if (!f) throw("'" + ast.value + "' not found");
      return f;
    case "List":
      return List(map(ast.data, lambda(Val e) { return EVAL(e, env); }));
    case "Vector":
      return Vector(map(ast.data, lambda(Val e) { return EVAL(e, env); }));
    case "Map":
      array(Val) elements = ({ });
      foreach(ast.data; Val k; Val v)
      {
        elements += ({ k, EVAL(v, env) });
      }
      return Map(elements);
    default:
      return ast;
  }
}

Val EVAL(Val ast, mapping(string:function) env)
{
  if(ast.type() != "List") return eval_ast(ast, env);
  if(ast.emptyp()) return ast;
  Val evaled_ast = eval_ast(ast, env);
  function f = evaled_ast.data[0];
  return f(@evaled_ast.data[1..]);
}

string PRINT(Val exp)
{
  return pr_str(exp);
}

string rep(string str, mapping(string:function) env)
{
  return PRINT(EVAL(READ(str), env));
}

int main()
{
  mapping(string:function) repl_env = ([
    "+": lambda(Val a, Val b) { return Number(a.value + b.value); },
    "-": lambda(Val a, Val b) { return Number(a.value - b.value); },
    "*": lambda(Val a, Val b) { return Number(a.value * b.value); },
    "/": lambda(Val a, Val b) { return Number(a.value / b.value); }
  ]);
  while(1)
  {
    string line = readline("user> ");
    if(!line) break;
    if(strlen(line) == 0) continue;
    if(mixed err = catch { write(({ rep(line, repl_env), "\n" })); } )
    {
      write(({ "Error: ", err, "\n" }));
    }
  }
  write("\n");
  return 0;
}
