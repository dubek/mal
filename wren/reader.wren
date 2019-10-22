import "pcre2" for Regexp
import "./types" for MalSymbol, MalList, MalVector, MalMap

class Reader {
  construct new(tokens) {
    _tokens = tokens
    _pos = 0
  }

  next() {
    if (_pos >= _tokens.count) return null
    var token = _tokens[_pos]
    _pos = _pos + 1
    return token
  }

  peek() {
    if (_pos >= _tokens.count) return null
    return _tokens[_pos]
  }
}

class MalReader {
  static token_re { Regexp.new("[\\s,]*(~@|[\\[\\]{}()'`~^@]|\"(?:\\\\.|[^\\\\\"])*\"?|;[^\n]*|[^\\s\\[\\]{}('\"`,;)]*)") }
  static string_re { Regexp.new("^\"(?:\\\\.|[^\\\\\"])*\"$") }
  static number_re { Regexp.new("^-?[0-9]+$") }

  static tokenize(s) {
    var tokens = []
    var offset = 0
    while (offset < s.count) {
      var m = token_re.match(s, offset)
      if (m.count == 0) break
      tokens.add(m[1])
      offset = m.endOffset(0)
    }
    return tokens
  }

  static parse_str(token) {
    return token[1..-2]
  }

  static read_atom(rdr) {
    var token = rdr.next()
    if (number_re.match(token).count > 0) return Num.fromString(token)
    if (string_re.match(token).count > 0) return parse_str(token)
    if (token.startsWith("\"")) Fiber.abort("expected '\"', got EOF")
    if (token.startsWith(":")) return "\u029e%(token[1..-1])" // keyword
    if (token == "nil") return null
    if (token == "true") return true
    if (token == "false") return false
    return MalSymbol.new(token)
  }

  static read_seq(rdr, start, end) {
    var token = rdr.next()
    if (token != start) Fiber.abort("expected '%(start)'")
    var elements = []
    token = rdr.peek()
    while (token != end) {
      if (!token) Fiber.abort("expected '%(end)', got EOF")
      elements.add(read_form(rdr))
      token = rdr.peek()
    }
    rdr.next()
    return elements
  }

  static reader_macro(rdr, sym) {
    rdr.next()
    return MalList.new([MalSymbol.new(sym), read_form(rdr)])
  }

  static read_form(rdr) {
    var token = rdr.peek()
    if (token == "'") return reader_macro(rdr, "quote")
    if (token == "`") return reader_macro(rdr, "quasiquote")
    if (token == "~") return reader_macro(rdr, "unquote")
    if (token == "~@") return reader_macro(rdr, "splice-unquote")
    if (token == "^") {
      rdr.next()
      var meta = read_form(rdr)
      return MalList.new([MalSymbol.new("with-meta"), read_form(rdr), meta])
    }
    if (token == "@") return reader_macro(rdr, "deref")
    if (token == "(") return MalList.new(read_seq(rdr, "(", ")"))
    if (token == ")") Fiber.abort("unexpected ')'")
    if (token == "[") return MalVector.new(read_seq(rdr, "[", "]"))
    if (token == "]") Fiber.abort("unexpected ']'")
    if (token == "{") return MalMap.fromList(read_seq(rdr, "{", "}"))
    if (token == "}") Fiber.abort("unexpected '}'")
    return read_atom(rdr)
  }

  static read_str(s) {
    var tokens = tokenize(s)
    if (tokens.count == 0) return null
    return read_form(Reader.new(tokens))
  }
}
