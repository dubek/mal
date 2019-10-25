import "./types" for MalList, MalVector, MalMap

class Printer {
  static joinElements(elements, print_readably) {
    return elements.map { |e| pr_str(e, print_readably) }.join(" ")
  }

  static joinMapElements(data, print_readably) {
    return data.map { |e| pr_str(e.key, print_readably) + " " + pr_str(e.value, print_readably) }.join(" ")
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
