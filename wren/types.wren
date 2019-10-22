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
}

class MalList is MalSequential {
  construct new(elements) { super(elements) }
}

class MalVector is MalSequential {
  construct new(elements) { super(elements) }
}

class MalMap is MalVal {
  construct fromList(elements) { _data = elements }
  data { _data }
}
