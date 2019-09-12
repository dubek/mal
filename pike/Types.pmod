class Val
{
  string to_string(bool print_readably);
  constant mal_type = "Val";

  bool `==(mixed other)
  {
    return objectp(other) && other.mal_type == mal_type;
  }
}

class Nil
{
  inherit Val;
  constant mal_type = "Nil";
  string to_string(bool print_readably)
  {
    return "nil";
  }
  int count()
  {
    return 0;
  }
}

Nil MAL_NIL = Nil();

class True
{
  inherit Val;
  constant mal_type = "True";
  string to_string(bool print_readably)
  {
    return "true";
  }
}

True MAL_TRUE = True();

class False
{
  inherit Val;
  constant mal_type = "False";
  string to_string(bool print_readably)
  {
    return "false";
  }
}

False MAL_FALSE = False();

Val to_bool(bool b)
{
  if(b) return MAL_TRUE;
  return MAL_FALSE;
}

class Number
{
  constant mal_type = "Number";
  inherit Val;
  int value;
  void create(int the_value)
  {
    value = the_value;
  }

  string to_string(bool print_readably)
  {
    return (string)value;
  }

  bool `==(mixed other)
  {
    return ::`==(other) && other.value == value;
  }
}

class Symbol
{
  constant mal_type = "Symbol";
  inherit Val;
  string value;
  void create(string the_value)
  {
    value = the_value;
  }

  string to_string(bool print_readably)
  {
    return value;
  }

  bool `==(mixed other)
  {
    return ::`==(other) && other.value == value;
  }
}

class String
{
  constant mal_type = "String";
  inherit Val;
  string value;
  void create(string the_value)
  {
    value = the_value;
  }

  string to_string(bool print_readably)
  {
    if (print_readably) {
      string s = replace(value, "\\", "\\\\");
      s = replace(s, "\"", "\\\"");
      s = replace(s, "\n", "\\n");
      return "\"" + s + "\"";
    }
    return value;
  }

  bool `==(mixed other)
  {
    return ::`==(other) && other.value == value;
  }
}

class Keyword
{
  constant mal_type = "Keyword";
  inherit Val;
  string value;
  void create(string the_value)
  {
    value = the_value;
  }

  string to_string(bool print_readably)
  {
    return ":" + value;
  }

  bool `==(mixed other)
  {
    return ::`==(other) && other.value == value;
  }
}

class Sequence
{
  inherit Val;
  array(Val) data;
  constant is_sequence = true;

  void create(array(Val) the_data)
  {
    data = the_data;
  }

  string to_string(bool print_readably)
  {
    return map(data, lambda(Val e) { return e.to_string(print_readably); }) * " ";
  }

  bool emptyp()
  {
    return sizeof(data) == 0;
  }

  int count()
  {
    return sizeof(data);
  }

  bool `==(mixed other)
  {
    if (!objectp(other)) return 0;
    if (!other.is_sequence) return 0;
    if(other.count() != count()) return 0;
    for(int i = 0; i < count(); i++)
    {
      if(other.data[i] != data[i]) return 0;
    }
    return 1;
  }
}

class List
{
  inherit Sequence;
  constant mal_type = "List";

  string to_string(bool print_readably)
  {
    return "(" + ::to_string(print_readably) + ")";
  }
}

class Vector
{
  inherit Sequence;
  constant mal_type = "Vector";

  string to_string(bool print_readably)
  {
    return "[" + ::to_string(print_readably) + "]";
  }
}

class Map
{
  inherit Val;
  constant mal_type = "Map";
  mapping(Val:Val) data;

  void create(array(Val) list)
  {
    array(Val) keys = Array.everynth(list, 2, 0);
    array(Val) vals = Array.everynth(list, 2, 1);
    data = mkmapping(keys, vals);
  }

  string to_string(bool print_readably)
  {
    array(string) strs = ({ });
    foreach(data; Val k; Val v)
    {
      strs += ({ k.to_string(print_readably), v.to_string(print_readably) });
    }
    return "{" + (strs * " ") + "}";
  }

  int count()
  {
    return sizeof(data);
  }
}
