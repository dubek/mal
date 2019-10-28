class MalVal {
  static newKeyword(value) { "\u029e%(value)" }
  static isKeyword(obj) { obj is String && obj.count > 0 && obj[0] == "\u029e" }
}

class MalSymbol is MalVal {
  construct new(value) { _value = value }
  value { _value }
  toString { _value }
  ==(other) { other is MalSymbol && other.value == _value }
  !=(other) { !(this == other) }
}

class MalSequential is MalVal {
  construct new(elements) { _elements = elements }
  elements { _elements }
  [index] { _elements[index] }
  isEmpty { _elements.count == 0 }
  count { _elements.count }
  first { isEmpty ? null : _elements[0] }
  rest { MalList.new(isEmpty ? [] : elements[1..-1]) }
  ==(other) {
    if (!(other is MalSequential)) return false
    if (other.count != count) return false
    for (i in 0...count) {
      if (other[i] != this[i]) return false
    }
    return true
    // System.print("DEBUG MalSequential.== called")
    // return other is MalSequential && other.elements == _elements
  }
  !=(other) { !(this == other) }
}

class MalList is MalSequential {
  construct new(elements) { super(elements) }
}

class MalVector is MalSequential {
  construct new(elements) { super(elements) }
}

class MalMap is MalVal {
  construct new(data) { _data = data }
  construct fromList(elements) {
    _data = {}
    var i = 0
    while (i < elements.count) {
      _data[elements[i]] = elements[i + 1]
      i = i + 2
    }
  }
  data { _data }
}

class MalFn is MalVal {
  construct new(ast, params, env, fn) {
    _ast = ast
    _params = params
    _env = env
    _fn = fn
    _isMacro = false
  }
  ast { _ast }
  params { _params }
  env { _env }
  isMacro { _isMacro }
  makeMacro() {
    _isMacro = true
    return this
  }
  call(args) { _fn.call(args) }
}

class MalAtom is MalVal {
  construct new(value) { _value = value }
  value { _value }
  value=(other) { _value = other }
}
