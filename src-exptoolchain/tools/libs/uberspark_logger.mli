
type log_level = None | Stdoutput | Error | Warn | Info | Debug
val ord : log_level -> int
val current_level : int ref
val error_level : int ref
val logf : string -> log_level -> ('a, unit, string, unit) format4 -> 'a
val log :
  ?tag:string ->
  ?stag:string ->
  ?lvl:log_level -> ?crlf:bool -> ('a, unit, string, unit) format4 -> 'a
