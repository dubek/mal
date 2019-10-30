import "io" for File
import "./reader" for MalReader
import "./readline" for Readline
import "./printer" for Printer
import "./types" for MalVal, MalSymbol, MalSequential, MalList, MalVector, MalMap, MalNativeFn, MalFn, MalAtom, MalException

class Core {
  static ns {
    return {
      "=":     MalNativeFn.new { |a| a[0] == a[1] },
      "throw": MalNativeFn.new { |a|
        MalException.set(a[0])
        Fiber.abort("___MalException___")
      },

      "nil?":     MalNativeFn.new { |a| a[0] == null },
      "true?":    MalNativeFn.new { |a| a[0] == true },
      "false?":   MalNativeFn.new { |a| a[0] == false },
      "string?":  MalNativeFn.new { |a| a[0] is String && !MalVal.isKeyword(a[0]) },
      "symbol":   MalNativeFn.new { |a| a[0] is MalSymbol ? a[0] : MalSymbol.new(a[0]) },
      "symbol?":  MalNativeFn.new { |a| a[0] is MalSymbol },
      "keyword":  MalNativeFn.new { |a| MalVal.isKeyword(a[0]) ? a[0] : MalVal.newKeyword(a[0]) },
      "keyword?": MalNativeFn.new { |a| MalVal.isKeyword(a[0]) },
      "number?":  MalNativeFn.new { |a| a[0] is Num },
      "fn?":      MalNativeFn.new { |a| a[0] is MalNativeFn || (a[0] is MalFn && !a[0].isMacro) },
      "macro?":   MalNativeFn.new { |a| a[0] is MalFn && a[0].isMacro },

      "pr-str":  MalNativeFn.new { |a| a.map { |e| Printer.pr_str(e, true) }.join(" ") },
      "str":     MalNativeFn.new { |a| a.map { |e| Printer.pr_str(e, false) }.join() },
      "prn":     MalNativeFn.new { |a|
                   System.print(a.map { |e| Printer.pr_str(e, true) }.join(" "))
                   return null
                 },
      "println": MalNativeFn.new { |a|
                   System.print(a.map { |e| Printer.pr_str(e, false) }.join(" "))
                   return null
                 },
      "read-string": MalNativeFn.new { |a| MalReader.read_str(a[0]) },
      "readline":    MalNativeFn.new { |a| Readline.readLine(a[0]) },
      "slurp":       MalNativeFn.new { |a| File.read(a[0]) },

      "<":       MalNativeFn.new { |a| a[0] < a[1] },
      "<=":      MalNativeFn.new { |a| a[0] <= a[1] },
      ">":       MalNativeFn.new { |a| a[0] > a[1] },
      ">=":      MalNativeFn.new { |a| a[0] >= a[1] },
      "+":       MalNativeFn.new { |a| a[0] + a[1] },
      "-":       MalNativeFn.new { |a| a[0] - a[1] },
      "*":       MalNativeFn.new { |a| a[0] * a[1] },
      "/":       MalNativeFn.new { |a| a[0] / a[1] },
      "time-ms": MalNativeFn.new { |a| (System.gettimeofday * 1000).floor },

      "list":      MalNativeFn.new { |a| MalList.new(a) },
      "list?":     MalNativeFn.new { |a| a[0] is MalList },
      "vector":    MalNativeFn.new { |a| MalVector.new(a) },
      "vector?":   MalNativeFn.new { |a| a[0] is MalVector },
      "hash-map":  MalNativeFn.new { |a| MalMap.fromList(a) },
      "map?":      MalNativeFn.new { |a| a[0] is MalMap },
      "assoc":     MalNativeFn.new { |a| a[0].assoc(a[1...a.count]) },
      "dissoc":    MalNativeFn.new { |a| a[0].dissoc(a[1...a.count]) },
      "get":       MalNativeFn.new { |a| a[0] == null ? null : a[0].data[a[1]] },
      "contains?": MalNativeFn.new { |a| a[0].data.containsKey(a[1]) },
      "keys":      MalNativeFn.new { |a| MalList.new(a[0].data.keys.toList) },
      "vals":      MalNativeFn.new { |a| MalList.new(a[0].data.values.toList) },

      "sequential?": MalNativeFn.new { |a| a[0] is MalSequential },
      "cons":        MalNativeFn.new { |a| MalList.new([a[0]] + a[1].elements) },
      "concat":      MalNativeFn.new { |a| MalList.new(a.reduce([]) { |acc,e| acc + e.elements }) },
      "nth":         MalNativeFn.new { |a| a[0][a[1]] || Fiber.abort("nth: index out of range") },
      "first":       MalNativeFn.new { |a| a[0] == null ? null : a[0].first },
      "rest":        MalNativeFn.new { |a| a[0] == null ? MalList.new([]) : a[0].rest },
      "empty?":      MalNativeFn.new { |a| a[0].isEmpty },
      "count":       MalNativeFn.new { |a| a[0] == null ? 0 : a[0].count },
      "apply":       MalNativeFn.new { |a| a[0].call(a[1...(a.count - 1)] + a[-1].elements) },
      "map":         MalNativeFn.new { |a| MalList.new(a[1].elements.map { |e| a[0].call([e]) }.toList) },

      "conj": MalNativeFn.new { |a|
                if (a[0] is MalList) {
                  var lst = []
                  for (e in a[1..-1]) lst.insert(0, e)
                  return MalList.new(lst + a[0].elements)
                }
                if (a[0] is MalVector) return MalVector.new(a[0].elements + a[1..-1])
              },
      "seq":  MalNativeFn.new { |a|
                if (a[0] == null) return null
                if (a[0].count == 0) return null
                if (a[0] is String) return MalList.new(a[0].toList)
                if (a[0] is MalVector) return MalList.new(a[0].elements)
                return a[0]
              },

      "meta":      MalNativeFn.new { |a| a[0].meta },
      "with-meta": MalNativeFn.new { |a|
                     var x = a[0].clone()
                     x.meta = a[1]
                     return x
                   },
      "atom":   MalNativeFn.new { |a| MalAtom.new(a[0]) },
      "atom?":  MalNativeFn.new { |a| a[0] is MalAtom },
      "deref":  MalNativeFn.new { |a| a[0].value },
      "reset!": MalNativeFn.new { |a| a[0].value = a[1] },
      "swap!":  MalNativeFn.new { |a| a[0].value = a[1].call([a[0].value] + a[2..-1]) }
    }
  }
}
