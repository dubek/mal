import "io" for Stdin, Stdout

class Mal {
  static readLine(prompt) {
    System.write("user> ")
    Stdout.flush()
    return Stdin.readLine()
  }

  static main() {
    while (true) {
      var line = readLine("user> ")
      if (line == null) break
      if (line != "") {
        System.print(line)
      }
    }
  }
}

Mal.main()
