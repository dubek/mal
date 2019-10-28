import "io" for File
import "./reader" for MalReader
import "./printer" for Printer
import "./types" for MalList, MalAtom

class Core {
  static ns {
    return {
      "=":  Fn.new { |a| a[0] == a[1] },

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

      "list":  Fn.new { |a| MalList.new(a) },
      "list?": Fn.new { |a| a[0] is MalList },

      "cons":   Fn.new { |a| MalList.new([a[0]] + a[1].elements) },
      "concat": Fn.new { |a| MalList.new(a.reduce([]) { |acc,e| acc + e.elements }) },
      "nth":    Fn.new { |a| a[0][a[1]] || Fiber.abort("nth: index out of range") },
      "first":  Fn.new { |a| a[0] == null ? null : a[0].first },
      "rest":   Fn.new { |a| a[0] == null ? MalList.new([]) : a[0].rest },
      "empty?": Fn.new { |a| a[0].isEmpty },
      "count":  Fn.new { |a| a[0] == null ? 0 : a[0].count },

      "atom":   Fn.new { |a| MalAtom.new(a[0]) },
      "atom?":  Fn.new { |a| a[0] is MalAtom },
      "deref":  Fn.new { |a| a[0].value },
      "reset!": Fn.new { |a| a[0].value = a[1] },
      "swap!":  Fn.new { |a| a[0].value = a[1].call([a[0].value] + a[2..-1]) }
    }
  }
}
