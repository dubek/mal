.Types.Val READ(string str)
{
  return .Reader.read_str(str);
}

.Types.Val EVAL(.Types.Val ast, string env)
{
  return ast;
}

string PRINT(.Types.Val exp)
{
  return .Printer.pr_str(exp);
}

string rep(string str)
{
  return PRINT(EVAL(READ(str), ""));
}

int main()
{
  while(1)
  {
    string line = .Readline.readline("user> ");
    if(!line) break;
    if(strlen(line) == 0) continue;
    if(mixed err = catch { write(({ rep(line), "\n" })); } )
    {
      write(({ "Error: ", err, "\n" }));
    }
  }
  write("\n");
  return 0;
}
