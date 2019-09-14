import .Printer;
import .Reader;
import .Types;

Val swap_bang(Val atom, mixed f, Val ... args)
{
  atom.data = f(@(({ atom.data }) + args));
  return atom.data;
}

mapping(string:function) NS = ([
  "=":  lambda(Val a, Val b) { return to_bool(a == b); },

  "pr-str":      lambda(Val ... a) { return String(map(a, lambda (Val e) { return pr_str(e, true); }) * " "); },
  "str":         lambda(Val ... a) { return String(map(a, lambda (Val e) { return pr_str(e, false); }) * ""); },
  "prn":         lambda(Val ... a) { write(({ map(a, lambda (Val e) { return pr_str(e, true); }) * " ", "\n" })); return MAL_NIL; },
  "println":     lambda(Val ... a) { write(({ map(a, lambda (Val e) { return pr_str(e, false); }) * " ", "\n" })); return MAL_NIL; },
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

  "list":  lambda(Val ... a) { return List(a); },
  "list?": lambda(Val a) { return to_bool(a.mal_type == "List"); },

  "empty?": lambda(Val a) { return to_bool(a.emptyp()); },
  "count":  lambda(Val a) { return Number(a.count()); },

  "atom":   lambda(Val a) { return Atom(a); },
  "atom?":  lambda(Val a) { return to_bool(a.mal_type == "Atom"); },
  "deref":  lambda(Val a) { return a.data; },
  "reset!": lambda(Val a, Val b) { a.data = b; return a.data; },
  "swap!":  swap_bang
]);
