import .Types;

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
    if(sizeof(m[1]) > 0 && m[1][0] != ';') tokens += ({ m[1] });
  });
  return tokens;
}

bool is_digit(int c)
{
  return '0' <= c && c <= '9';
}

string unescape_string(string token)
{
  if(!string_regexp.match(token)) throw("expected '\"', got EOF");
  string s = token[1..(sizeof(token) - 2)];
  s = replace(s, "\\\\", "\u029e");
  s = replace(s, "\\\"", "\"");
  s = replace(s, "\\n", "\n");
  s = replace(s, "\u029e", "\\");
  return s;
}

Val read_atom(Reader reader)
{
  string token = reader->next();
  if(number_regexp.match(token)) return Number((int)token);
  if(token[0] == '"') return String(unescape_string(token));
  if(token[0] == ':') return Keyword(token[1..]);
  switch(token)
  {
    case "nil":   return MAL_NIL;
    case "true":  return MAL_TRUE;
    case "false": return MAL_FALSE;
  }
  return Symbol(token);
}

array(Val) read_seq(Reader reader, string start, string end)
{
  string token = reader->next();
  if(token != start) throw("expected '" + start + "'");
  token = reader->peek();
  array(Val) elements = ({ });
  while(token != end)
  {
    if(!token) throw("expected '" + end + "', got EOF");
    elements += ({ read_form(reader) });
    token = reader->peek();
  }
  reader->next();
  return elements;
}

Val reader_macro(Reader reader, string symbol)
{
  reader->next();
  return List(({ Symbol(symbol), read_form(reader) }));
}

Val read_form(Reader reader)
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
      Val meta = read_form(reader);
      return List(({ Symbol("with-meta"), read_form(reader), meta }));
    case "(":
      return List(read_seq(reader, "(", ")"));
    case ")":
      throw("unexpected ')'");
    case "[":
      return Vector(read_seq(reader, "[", "]"));
    case "]":
      throw("unexpected ']'");
    case "{":
      return Map(read_seq(reader, "{", "}"));
    case "}":
      throw("unexpected '}'");
    default:
      return read_atom(reader);
  }
}

Val read_str(string str)
{
  array(string) tokens = tokenize(str);
  if(sizeof(tokens) == 0) return MAL_NIL;
  return read_form(Reader(tokens));
}
