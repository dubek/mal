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
  inherit Sequence;

  string toString()
  {
    return "{" + ::toString() + "}";
  }
}
