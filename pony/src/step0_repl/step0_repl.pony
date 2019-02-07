use "cli"
use "files"
use "promises"
use "term"
use "../mal"

class Step0 is MalRuntime
  let _env: Env

  new iso create(env: Env) =>
    _env = env

  fun ref process_line(line: String) =>
    let clean_line: String val = recover line.clone().>strip() end
    if clean_line.size() > 0 then
      _env.out.print(clean_line)
    end

actor Main
  new create(env: Env) =>
    MalReadline.main_loop(env, Step0(env))
