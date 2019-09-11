class Val
{
  string toString();
}

class Nil
{
  constant mal_type = "Nil";
  string toString()
  {
    return "nil";
  }
}

Nil MAL_NIL = Nil();

class True
{
  constant mal_type = "True";
  string toString()
  {
    return "true";
  }
}

True MAL_TRUE = True();

class False
{
  constant mal_type = "False";
  string toString()
  {
    return "false";
  }
}

False MAL_FALSE = False();

class Number
{
  constant mal_type = "Number";
  inherit Val;
  int value;
  void create(int the_value)
  {
    value = the_value;
  }

  string toString()
  {
    return (string)value;
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

  string toString()
  {
    return value;
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

  string toString()
  {
    string s = replace(value, "\\", "\\\\");
    s = replace(s, "\"", "\\\"");
    s = replace(s, "\n", "\\n");
    return "\"" + s + "\"";
  }
}

class Sequence
{
  inherit Val;
  array(Val) data;

  void create(array(Val) the_data)
  {
    data = the_data;
  }

  string toString()
  {
    return map(data, lambda(Val e) { return e.toString(); }) * " ";
  }

  bool emptyp()
  {
    return sizeof(data) == 0;
  }
}

class List
{
  inherit Sequence;
  constant mal_type = "List";

  string toString()
  {
    return "(" + ::toString() + ")";
  }
}

class Vector
{
  inherit Sequence;
  constant mal_type = "Vector";

  string toString()
  {
    return "[" + ::toString() + "]";
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

  string toString()
  {
    array(string) strs = ({ });
    foreach(data; Val k; Val v)
    {
      strs += ({ k.toString(), v.toString() });
    }
    return "{" + (strs * " ") + "}";
  }
}
