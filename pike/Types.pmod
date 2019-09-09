class MalType
{
  string toString();
}

class MalNumber
{
  inherit MalType;
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

class MalSymbol
{
  inherit MalType;
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

class MalList
{
  inherit MalType;
  array(MalType) data;

  void create(array(MalType) the_data)
  {
    data = the_data;
  }

  string toString()
  {
    return "(" + (map(data, lambda(MalType e) { return e.toString(); }) * " ") + ")";
  }
}
