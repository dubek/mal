import "io" for Stdin, Stdout

class Readline {
  static readLine(prompt) {
    System.write(prompt)
    Stdout.flush()
    return Stdin.readLine()
  }
}
