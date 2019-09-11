.Types.Val READ(string str)
{
  return .Reader.read_str(str);
}

.Types.Val eval_ast(.Types.Val ast, mapping(string:function) env)
{
  string ast_type = ast.type();
  //write("eval_ast: ast_type=%s\n", ast_type);
  switch(ast_type)
  {
    case "Symbol":
      function f = env[ast.value];
      if (!f) throw("'" + ast.value + "' not found");
      return f;
    case "List":
      return .Types.List(map(ast.data, lambda(.Types.Val e) { return EVAL(e, env); }));
    case "Vector":
      return .Types.Vector(map(ast.data, lambda(.Types.Val e) { return EVAL(e, env); }));
    case "Map":
      array(.Types.Val) elements = ({ });
      foreach(ast.data; .Types.Val k; .Types.Val v)
      {
        elements += ({ k, EVAL(v, env) });
      }
      return .Types.Map(elements);
    default:
      return ast;
  }
}

.Types.Val EVAL(.Types.Val ast, mapping(string:function) env)
{
  string ast_type = ast.type();
  //write("EVAL: ast_type=%s\n", ast_type);
  if(ast_type != "List") return eval_ast(ast, env);
  if(ast.emptyp()) return ast;
  .Types.Val evaled_ast = eval_ast(ast, env);
  function f = evaled_ast.data[0];
  return f(evaled_ast.data[1], evaled_ast.data[2]);
}

string PRINT(.Types.Val exp)
{
  return .Printer.pr_str(exp);
}

string rep(string str, mapping(string:function) env)
{
  return PRINT(EVAL(READ(str), env));
}

int main()
{
  mapping(string:function) repl_env = ([
    "+": lambda(.Types.Val a, .Types.Val b) { return .Types.Number(a.value + b.value); },
    "-": lambda(.Types.Val a, .Types.Val b) { return .Types.Number(a.value - b.value); },
    "*": lambda(.Types.Val a, .Types.Val b) { return .Types.Number(a.value * b.value); },
    "/": lambda(.Types.Val a, .Types.Val b) { return .Types.Number(a.value / b.value); }
  ]);
  while(1)
  {
    string line = .Readline.readline("user> ");
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
