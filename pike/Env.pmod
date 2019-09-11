import .Types;

class Env
{
  Env outer;
  mapping(string:Val) data;

  void create(Env the_outer)
  {
    outer = the_outer;
    data = ([ ]);
  }

  Val set(Val key, Val val)
  {
    data[key.value] = val;
    return val;
  }

  Env find(string key_str)
  {
    if (data[key_str]) return this_object();
    if (outer) return outer.find(key_str);
    return 0;
  }

  Val get(Val key)
  {
    Env found_env = find(key.value);
    if (!found_env) throw("'" + key.value + "' not found");
    return found_env.data[key.value];
  }
}
