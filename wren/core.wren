import "./printer" for Printer
import "./types" for MalList

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

      "empty?": Fn.new { |a| a[0].isEmpty },
      "count":  Fn.new { |a| a[0] == null ? 0 : a[0].count }
    }
  }
}
