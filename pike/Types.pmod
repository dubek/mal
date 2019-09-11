class Val
{
  string toString();
  string type()
  {
    return function_name(object_program(this_object()));
  }
}

class Nil
{
  string toString()
  {
    return "nil";
  }
  string type()
  {
    return "Nil";
  }
}

Nil MAL_NIL = Nil();

class True
{
  string toString()
  {
    return "true";
  }
  string type()
  {
    return "True";
  }
}

True MAL_TRUE = True();

class False
{
  string toString()
  {
    return "false";
  }
  string type()
  {
    return "False";
  }
}

False MAL_FALSE = False();

class Number
{
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

  string toString()
  {
    return "(" + ::toString() + ")";
  }
}

class Vector
{
  inherit Sequence;

  string toString()
  {
    return "[" + ::toString() + "]";
  }
}

class Map
{
  inherit Val;
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
