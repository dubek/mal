class MalVal {
  static newKeyword(value) { "\u029e%(value)" }
  static isKeyword(obj) { obj is String && obj.count > 0 && obj[0] == "\u029e" }
}

class MalSymbol is MalVal {
  construct new(value) { _value = value }
  value { _value }
  toString { _value }
}

class MalSequential is MalVal {
  construct new(elements) { _elements = elements }
  elements { _elements }
  [index] { _elements[index] }
  isEmpty { _elements.count == 0 }
  count { _elements.count }
  rest { drop(1) }
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
  drop(index) { MalList.new(elements[index..-1]) }
}

class MalVector is MalSequential {
  construct new(elements) { super(elements) }
  drop(index) { MalVector.new(elements[index..-1]) }
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
  }
  ast { _ast }
  params { _params }
  env { _env }
  call(args) { _fn.call(args) }
}
