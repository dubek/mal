class Val
{
  string toString();
}

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
    array(Val) values = Array.everynth(list, 2, 1);
    data = mkmapping(keys, values);
  }

  string toString()
  {
    array(string) strs = ({ });
    foreach(indices(data), Val key)
    {
      strs += ({ key.toString(), data[key].toString() });
    }
    return "{" + (strs * " ") + "}";
  }
}
