class Val
{
  constant mal_type = "Val";
  Val meta;
  string to_string(bool print_readably);
  Val clone();

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

  Val first()
  {
    return MAL_NIL;
  }

  Val rest()
  {
    return List(({ }));
  }

  Val clone()
  {
    return this_object();
  }

  Val seq()
  {
    return MAL_NIL;
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

  Val clone()
  {
    return this_object();
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

  Val clone()
  {
    return this_object();
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

  Val clone()
  {
    return this_object();
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

  int __hash()
  {
     return hash(mal_type) ^ hash(value);
  }

  Val clone()
  {
    return Symbol(value);
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

  int __hash()
  {
     return hash(mal_type) ^ hash(value);
  }

  Val clone()
  {
    return String(value);
  }

  Val seq()
  {
    if(sizeof(value) == 0) return MAL_NIL;
    array(Val) parts = ({ });
    for(int i = 0; i < sizeof(value); i++)
    {
      parts += ({ String(value[i..i]) });
    }
    return List(parts);
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

  int __hash()
  {
     return hash(mal_type) ^ hash(value);
  }

  Val clone()
  {
    return Keyword(value);
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

  Val nth(int index)
  {
    if(index >= count()) throw("nth: index out of range");
    return data[index];
  }

  Val first()
  {
    if(emptyp()) return MAL_NIL;
    return data[0];
  }

  Val rest()
  {
    return List(data[1..]);
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

  Val seq()
  {
    if(emptyp()) return MAL_NIL;
    return List(data);
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

  Val clone()
  {
    return List(data);
  }

  Val conj(array(Val) other)
  {
    return List(reverse(other) + data);
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

  Val clone()
  {
    return Vector(data);
  }

  Val conj(array(Val) other)
  {
    return Vector(data + other);
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

  bool `==(mixed other)
  {
    if (!::`==(other)) return 0;
    if(other.count() != count()) return 0;
    foreach(data; Val k; Val v)
    {
      if(other.data[k] != v) return 0;
    }
    return 1;
  }

  Val assoc(array(Val) list)
  {
    array(Val) keys = Array.everynth(list, 2, 0);
    array(Val) vals = Array.everynth(list, 2, 1);
    Map result = Map(({ }));
    result.data = copy_value(data);
    for(int i = 0; i < sizeof(keys); i++)
    {
      result.data[keys[i]] = vals[i];
    }
    return result;
  }

  Val dissoc(array(Val) list)
  {
    Map result = Map(({ }));
    result.data = copy_value(data);
    foreach(list, Val key) m_delete(result.data, key);
    return result;
  }

  Val clone()
  {
    Map m = Map(({ }));
    m.data = data;
    return m;
  }
}

class Fn
{
  inherit Val;
  constant mal_type = "Fn";
  constant is_fn = true;
  Val ast;
  Val params;
  .Env.Env env;
  function func;
  bool macro;

  void create(Val the_ast, Val the_params, .Env.Env the_env, function the_func, void|bool is_macro)
  {
    ast = the_ast;
    params = the_params;
    env = the_env;
    func = the_func;
    macro = is_macro ? true : false;
  }

  void set_macro()
  {
    macro = true;
  }

  string to_string(bool print_readably)
  {
    string tag = macro ? "Macro" : "Fn";
    return "#<" + tag + " params=" + params.to_string(true) + ">";
  }

  mixed `()(mixed ... args)
  {
    return func(@args);
  }

  Val clone()
  {
    return Fn(ast, params, env, func);
  }

  Val clone_as_macro()
  {
    return Fn(ast, params, env, func, true);
  }
}

class BuiltinFn
{
  inherit Val;
  constant mal_type = "BuiltinFn";
  constant is_fn = true;
  string name;
  function func;

  void create(string the_name, function the_func)
  {
    name = the_name;
    func = the_func;
  }

  string to_string(bool print_readably)
  {
    return "#<BuiltinFn " + name + ">";
  }

  mixed `()(mixed ... args)
  {
    return func(@args);
  }

  Val clone()
  {
    return BuiltinFn(name, func);
  }
}

class Atom
{
  inherit Val;
  constant mal_type = "Atom";
  Val data;

  void create(Val the_data)
  {
    data = the_data;
  }

  string to_string(bool print_readably)
  {
    return "(atom " + data.to_string(print_readably) + ")";
  }

  Val clone()
  {
    return Atom(data);
  }
}
