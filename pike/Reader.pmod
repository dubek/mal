Regexp.PCRE tokenizerRegexp = Regexp.PCRE.Studied("[\\s ,]*(~@|[\\[\\]{}()'`~@]|\"([\\\\].|[^\\\\\"])*\"?|;.*|[^\\s \\[\\]{}()'\"`~@,;]*)");

class Reader
{
  array(string) tokens;
  int position;

  void create(array(string) the_tokens)
  {
    tokens = the_tokens;
  }

  string next()
  {
    if(position >= sizeof(tokens)) return 0;
    string token = tokens[position];
    position++;
    return token;
  }

  string peek()
  {
    if(position >= sizeof(tokens)) return 0;
    return tokens[position];
  }
}

array(string) tokenize(string str)
{
  array(string) tokens = ({ });
  tokenizerRegexp.matchall(str, lambda(mixed m) {
    if(sizeof(m[1]) > 0) tokens += ({ m[1] });
  });
  return tokens;
}

bool is_digit(int c)
{
  return '0' <= c && c <= '9';
}

.Types.MalType read_atom(Reader reader)
{
  string token = reader->next();
  if(is_digit(token[0])) return .Types.MalNumber((int)token);
  return .Types.MalSymbol(token);
}

.Types.MalType read_list(Reader reader)
{
  string start = "(";
  string end = ")";
  string token = reader->next();
  if(token != start) throw("expected '" + start + "'");
  token = reader->peek();
  array(.Types.MalType) list = ({ });
  while(token != end)
  {
    if(!token) throw("expected '" + end + "', got EOF");
    list += ({ read_form(reader) });
    token = reader->peek();
  }
  reader->next();
  return .Types.MalList(list);
}

.Types.MalType reader_macro(Reader reader, string symbol)
{
  reader->next();
  return .Types.MalList(({ .Types.MalSymbol(symbol), read_form(reader) }));
}

.Types.MalType read_form(Reader reader)
{
  string token = reader->peek();
  switch(token)
  {
    case "'":
      return reader_macro(reader, "quote");
    case "`":
      return reader_macro(reader, "quasiquote");
    case "~":
      return reader_macro(reader, "unquote");
    case "~@":
      return reader_macro(reader, "splice-unquote");
    case "(":
      return read_list(reader);
    case ")":
      throw("unexpected ')'");
    case "[":
      return read_list(reader);
    case "]":
      throw("unexpected ']'");
    case "{":
      return read_list(reader);
    case "}":
      throw("unexpected '}'");
    default:
      return read_atom(reader);
  }
}

.Types.MalType read_str(string str)
{
  return read_form(Reader(tokenize(str)));
}
