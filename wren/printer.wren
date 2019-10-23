import "./types" for MalList, MalVector, MalMap

class Printer {
  static joinElements(elements, print_readably) {
    var s = ""
    for (e in elements) {
      var e_str = pr_str(e, print_readably)
      if (s == "") {
        s = s + e_str
      } else {
        s = s + " " + e_str
      }
    }
    return s
  }

  static joinMapElements(data, print_readably) {
    var s = ""
    for (e in data) {
      var e_str = pr_str(e, print_readably)
      if (s == "") {
        s = s + e_str
      } else {
        s = s + " " + e_str
      }
    }
    return s
  }

  static pr_str(obj) { pr_str(obj, true) }

  static pr_str(obj, print_readably) {
    if (obj == null) return "nil"
    if (obj is MalList) return "(%(joinElements(obj.elements, print_readably)))"
    if (obj is MalVector) return "[%(joinElements(obj.elements, print_readably))]"
    if (obj is MalMap) return "{%(joinMapElements(obj.data, print_readably))}"
    if (obj is String) {
      if (obj.count > 0 && obj[0] == "\u029e") return ":%(obj[1..-1])"
      return print_readably ? "\"%(obj)\"" : obj
    }
    return obj.toString
  }
}
