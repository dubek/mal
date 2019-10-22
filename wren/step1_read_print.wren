import "./readline" for Readline
import "./reader" for MalReader
import "./printer" for Printer

class Mal {

  static read(str) {
    return MalReader.read_str(str)
  }

  static eval(ast, env) {
    return ast
  }

  static print(ast) {
    return Printer.pr_str(ast)
  }

  static rep(str) {
    return print(eval(read(str), null))
  }

  static main() {
    while (true) {
      var line = null
      var fiber = Fiber.new {
        line = Readline.readLine("user> ")
        if (line != "") System.print(rep(line))
      }
      var error = fiber.try()
      if (line == null) break
      if (error) System.print("Error: %(error)")
    }
    System.print("")
  }
}

Mal.main()
