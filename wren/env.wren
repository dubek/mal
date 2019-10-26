class Env {
  construct new() {
    _outer = null
    _data = {}
  }
  construct new(outer) {
    _outer = outer
    _data = {}
  }

  set(k, v) {
    _data[k] = v
    return v
  }

  find(k) {
    if (_data.containsKey(k)) return this
    if (_outer) return _outer.find(k)
    return null
  }

  get(k) {
    var foundEnv = find(k)
    if (!foundEnv) Fiber.abort("'%(k)' not found")
    return foundEnv.getValue(k)
  }

  getValue(k) { _data[k] }
}
