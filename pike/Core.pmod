import .Printer;
import .Reader;
import .Types;

private Val apply(mixed f, Val ... args)
{
  if(sizeof(args) == 1) return f(@args[0].data);
  array(Val) mid_args = args[0..(sizeof(args) - 2)];
  return f(@(mid_args + args[-1].data));
}

private Val swap_bang(Val atom, mixed f, Val ... args)
{
  atom.data = f(@(({ atom.data }) + args));
  return atom.data;
}

private mapping(string:function) builtins = ([
  "=":     lambda(Val a, Val b) { return to_bool(a == b); },
  "throw": lambda(Val a) { throw(a); },

  "nil?":     lambda(Val a) { return to_bool(a.mal_type == "Nil"); },
  "true?":    lambda(Val a) { return to_bool(a.mal_type == "True"); },
  "false?":   lambda(Val a) { return to_bool(a.mal_type == "False"); },
  "symbol":   lambda(Val a) { return a.mal_type == "Symbol" ? a : Symbol(a.value); },
  "symbol?":  lambda(Val a) { return to_bool(a.mal_type == "Symbol"); },
  "keyword":  lambda(Val a) { return a.mal_type == "Keyword" ? a : Keyword(a.value); },
  "keyword?": lambda(Val a) { return to_bool(a.mal_type == "Keyword"); },

  "pr-str":      lambda(Val ... a) { return String(map(a, lambda(Val e) { return pr_str(e, true); }) * " "); },
  "str":         lambda(Val ... a) { return String(map(a, lambda(Val e) { return pr_str(e, false); }) * ""); },
  "prn":         lambda(Val ... a) { write(({ map(a, lambda(Val e) { return pr_str(e, true); }) * " ", "\n" })); return MAL_NIL; },
  "println":     lambda(Val ... a) { write(({ map(a, lambda(Val e) { return pr_str(e, false); }) * " ", "\n" })); return MAL_NIL; },
  "read-string": lambda(Val a) { return read_str(a.value); },
  "slurp":       lambda(Val a) { return String(Stdio.read_file(a.value)); },

  "<":  lambda(Val a, Val b) { return to_bool(a.value < b.value); },
  "<=": lambda(Val a, Val b) { return to_bool(a.value <= b.value); },
  ">":  lambda(Val a, Val b) { return to_bool(a.value > b.value); },
  ">=": lambda(Val a, Val b) { return to_bool(a.value >= b.value); },
  "+":  lambda(Val a, Val b) { return Number(a.value + b.value); },
  "-":  lambda(Val a, Val b) { return Number(a.value - b.value); },
  "*":  lambda(Val a, Val b) { return Number(a.value * b.value); },
  "/":  lambda(Val a, Val b) { return Number(a.value / b.value); },

  "list":      lambda(Val ... a) { return List(a); },
  "list?":     lambda(Val a) { return to_bool(a.mal_type == "List"); },
  "vector":    lambda(Val ... a) { return Vector(a); },
  "vector?":   lambda(Val a) { return to_bool(a.mal_type == "Vector"); },
  "hash-map":  lambda(Val ... a) { return Map(a); },
  "map?":      lambda(Val a) { return to_bool(a.mal_type == "Map"); },
  "assoc":     lambda(Val a, Val ... b) { return a.assoc(b); },
  "dissoc":    lambda(Val a, Val ... b) { return a.dissoc(b); },
  "get":       lambda(Val a, Val b) { return a.mal_type != "Nil" ? (a.data[b] || MAL_NIL) : MAL_NIL; },
  "contains?": lambda(Val a, Val b) { return to_bool(a.data[b]); },
  "keys":      lambda(Val a) { return List(indices(a.data)); },
  "vals":      lambda(Val a) { return List(values(a.data)); },

  "sequential?": lambda(Val a) { return to_bool(a.is_sequence); },
  "cons":        lambda(Val a, Val b) { return List(({ a }) + b.data); },
  "concat":      lambda(Val ... a) { return List(`+(({ }), @map(a, lambda(Val e) { return e.data; }))); },
  "nth":         lambda(Val a, Val b) { return a.nth(b.value); },
  "first":       lambda(Val a) { return a.first(); },
  "rest":        lambda(Val a) { return a.rest(); },
  "empty?":      lambda(Val a) { return to_bool(a.emptyp()); },
  "count":       lambda(Val a) { return Number(a.count()); },
  "apply":       apply,
  "map":         lambda(mixed f, Val a) { return List(map(a.data, f)); },

  "atom":   lambda(Val a) { return Atom(a); },
  "atom?":  lambda(Val a) { return to_bool(a.mal_type == "Atom"); },
  "deref":  lambda(Val a) { return a.data; },
  "reset!": lambda(Val a, Val b) { a.data = b; return a.data; },
  "swap!":  swap_bang
]);

mapping(Val:Val) NS()
{
  mapping(Val:Val) ns = ([ ]);
  foreach(builtins; string name; function f) { ns[Symbol(name)] = BuiltinFn(name, f); }
  return ns;
}
