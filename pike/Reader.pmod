Regexp.PCRE tokenizer_regexp = Regexp.PCRE.Studied("[\\s ,]*(~@|[\\[\\]{}()'`~@]|\"([\\\\].|[^\\\\\"])*\"?|;.*|[^\\s \\[\\]{}()'\"`~@,;]*)");
Regexp.PCRE string_regexp = Regexp.PCRE.Studied("^\"(?:[\\\\].|[^\\\\\"])*\"$");
Regexp.PCRE number_regexp = Regexp.PCRE.Studied("^-?[0-9]+$");

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
  tokenizer_regexp.matchall(str, lambda(mixed m) {
    if(sizeof(m[1]) > 0) tokens += ({ m[1] });
  });
  return tokens;
}

bool is_digit(int c)
{
  return '0' <= c && c <= '9';
}

.Types.Val unescape_string(string token)
{
  if(!string_regexp.match(token)) throw("expected '\"', got EOF");
  string s = token[1..(sizeof(token) - 2)];
  s = replace(s, "\\\\", "\u029e");
  s = replace(s, "\\\"", "\"");
  s = replace(s, "\\n", "\n");
  s = replace(s, "\u029e", "\\");
  return .Types.String(s);
}

.Types.Val read_atom(Reader reader)
{
  string token = reader->next();
  if(number_regexp.match(token)) return .Types.Number((int)token);
  if(token[0] == '"') return unescape_string(token);
  return .Types.Symbol(token);
}

array(.Types.Val) read_seq(Reader reader, string start, string end)
{
  string token = reader->next();
  if(token != start) throw("expected '" + start + "'");
  token = reader->peek();
  array(.Types.Val) elements = ({ });
  while(token != end)
  {
    if(!token) throw("expected '" + end + "', got EOF");
    elements += ({ read_form(reader) });
    token = reader->peek();
  }
  reader->next();
  return elements;
}

.Types.Val reader_macro(Reader reader, string symbol)
{
  reader->next();
  return .Types.List(({ .Types.Symbol(symbol), read_form(reader) }));
}

.Types.Val read_form(Reader reader)
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
    case "@":
      return reader_macro(reader, "deref");
    case "^":
      reader->next();
      .Types.Val meta = read_form(reader);
      return .Types.List(({ .Types.Symbol("with-meta"), read_form(reader), meta }));
    case "(":
      return .Types.List(read_seq(reader, "(", ")"));
    case ")":
      throw("unexpected ')'");
    case "[":
      return .Types.Vector(read_seq(reader, "[", "]"));
    case "]":
      throw("unexpected ']'");
    case "{":
      return .Types.Map(read_seq(reader, "{", "}"));
    case "}":
      throw("unexpected '}'");
    default:
      return read_atom(reader);
  }
}

.Types.Val read_str(string str)
{
  return read_form(Reader(tokenize(str)));
}
