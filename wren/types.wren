class MalVal {
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
