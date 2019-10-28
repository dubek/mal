import "io" for File
import "./reader" for MalReader
import "./printer" for Printer
import "./types" for MalVal, MalSymbol, MalSequential, MalList, MalVector, MalMap, MalAtom, MalException

class Core {
  static ns {
    return {
      "=":     Fn.new { |a| a[0] == a[1] },
      "throw": Fn.new { |a|
        MalException.set(a[0])
        Fiber.abort("___MalException___")
      },

      "nil?":     Fn.new { |a| a[0] == null },
      "true?":    Fn.new { |a| a[0] == true },
      "false?":   Fn.new { |a| a[0] == false },
      "symbol":   Fn.new { |a| a[0] is MalSymbol ? a[0] : MalSymbol.new(a[0]) },
      "symbol?":  Fn.new { |a| a[0] is MalSymbol },
      "keyword":  Fn.new { |a| MalVal.isKeyword(a[0]) ? a[0] : MalVal.newKeyword(a[0]) },
      "keyword?": Fn.new { |a| MalVal.isKeyword(a[0]) },

      "pr-str":  Fn.new { |a| a.map { |e| Printer.pr_str(e, true) }.join(" ") },
      "str":     Fn.new { |a| a.map { |e| Printer.pr_str(e, false) }.join() },
      "prn":     Fn.new { |a|
                   System.print(a.map { |e| Printer.pr_str(e, true) }.join(" "))
                   return null
                 },
      "println": Fn.new { |a|
                   System.print(a.map { |e| Printer.pr_str(e, false) }.join(" "))
                   return null
                 },
      "read-string": Fn.new { |a| MalReader.read_str(a[0]) },
      "slurp":       Fn.new { |a| File.read(a[0]) },

      "<":  Fn.new { |a| a[0] < a[1] },
      "<=": Fn.new { |a| a[0] <= a[1] },
      ">":  Fn.new { |a| a[0] > a[1] },
      ">=": Fn.new { |a| a[0] >= a[1] },
      "+":  Fn.new { |a| a[0] + a[1] },
      "-":  Fn.new { |a| a[0] - a[1] },
      "*":  Fn.new { |a| a[0] * a[1] },
      "/":  Fn.new { |a| a[0] / a[1] },

      "list":      Fn.new { |a| MalList.new(a) },
      "list?":     Fn.new { |a| a[0] is MalList },
      "vector":    Fn.new { |a| MalVector.new(a) },
      "vector?":   Fn.new { |a| a[0] is MalVector },
      "hash-map":  Fn.new { |a| MalMap.fromList(a) },
      "map?":      Fn.new { |a| a[0] is MalMap },
      "assoc":     Fn.new { |a| a[0].assoc(a[1...a.count]) },
      "dissoc":    Fn.new { |a| a[0].dissoc(a[1...a.count]) },
      "get":       Fn.new { |a| a[0] == null ? null : a[0].data[a[1]] },
      "contains?": Fn.new { |a| a[0].data.containsKey(a[1]) },
      "keys":      Fn.new { |a| MalList.new(a[0].data.keys.toList) },
      "vals":      Fn.new { |a| MalList.new(a[0].data.values.toList) },

      "sequential?": Fn.new { |a| a[0] is MalSequential },
      "cons":        Fn.new { |a| MalList.new([a[0]] + a[1].elements) },
      "concat":      Fn.new { |a| MalList.new(a.reduce([]) { |acc,e| acc + e.elements }) },
      "nth":         Fn.new { |a| a[0][a[1]] || Fiber.abort("nth: index out of range") },
      "first":       Fn.new { |a| a[0] == null ? null : a[0].first },
      "rest":        Fn.new { |a| a[0] == null ? MalList.new([]) : a[0].rest },
      "empty?":      Fn.new { |a| a[0].isEmpty },
      "count":       Fn.new { |a| a[0] == null ? 0 : a[0].count },
      "apply":       Fn.new { |a| a[0].call(a[1...(a.count - 1)] + a[-1].elements) },
      "map":         Fn.new { |a| MalList.new(a[1].elements.map { |e| a[0].call([e]) }.toList) },

      "atom":   Fn.new { |a| MalAtom.new(a[0]) },
      "atom?":  Fn.new { |a| a[0] is MalAtom },
      "deref":  Fn.new { |a| a[0].value },
      "reset!": Fn.new { |a| a[0].value = a[1] },
      "swap!":  Fn.new { |a| a[0].value = a[1].call([a[0].value] + a[2..-1]) }
    }
  }
}
