use "cli"
use "files"
use "promises"
use "term"

class MalReadlineHandler is ReadlineNotify
  let _mal_runtime: MalRuntime
  let _main_prompt: String

  new create(mal_runtime: MalRuntime, main_prompt: String) =>
    _mal_runtime = consume mal_runtime
    _main_prompt = main_prompt

  fun ref apply(line: String, prompt: Promise[String]) =>
    _mal_runtime.process_line(line)
    prompt(_main_prompt)

class MalReadline
  //let _env: Env
  //let _mal_runtime: MalRuntime

  //new create(env: Env, mal_runtime: MalRuntime) =>
  //  _env = env
  //  _mal_runtime = consume mal_runtime

  fun main_loop(env: Env, mal_runtime: MalRuntime iso) =>
    try
      let prompt = "user> "
      let envvars = EnvVars(env.vars)
      let home_dirname = envvars.get_or_else("HOME", ".")
      let history_path = FilePath(env.root as AmbientAuth, home_dirname)?.join(".mal-history")?
      let term = ANSITerm(Readline(recover MalReadlineHandler(consume mal_runtime, prompt) end, env.out, history_path), env.input)
      term.prompt(prompt)

      let notify = object iso
        let term: ANSITerm = term
        fun ref apply(data: Array[U8] iso) => term(consume data)
        fun ref dispose() => term.dispose()
      end

      env.input(consume notify)
    end

  // fun ref start_loop() =>
  //   try
  //     let prompt = "user> "
  //     let envvars = EnvVars(_env.vars)
  //     let home_dirname = envvars.get_or_else("HOME", ".")
  //     let history_path = FilePath(_env.root as AmbientAuth, home_dirname)?.join(".mal-history")?
  //     let term = ANSITerm(Readline(recover MalReadlineHandler(_mal_runtime, prompt) end, _env.out, history_path), _env.input)
  //     term.prompt(prompt)

  //     let notify = object iso
  //       let term: ANSITerm = term
  //       fun ref apply(data: Array[U8] iso) => term(consume data)
  //       fun ref dispose() => term.dispose()
  //     end

  //     _env.input(consume notify)
  //   end
