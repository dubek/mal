import "./readline" for Readline

class Mal {

  static read(str) {
    return str
  }

  static eval(ast, env) {
    return ast
  }

  static print(ast) {
    return ast
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
      fiber.try()
      if (line == null) break
    }
  }
}

Mal.main()
