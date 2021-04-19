
type log_level = None | Stdoutput | Error | Warn | Info | Debug
val ord : log_level -> int
val current_level : int ref
val error_level : int ref

val log_tag : string ref

val log_print_string_fn : (string -> unit) ref
val log_print_newline_fn : (unit -> unit) ref

val log :
  ?tag:string ->
  ?stag:string ->
  ?lvl:log_level -> ?crlf:bool -> ('a, unit, string, unit) format4 -> 'a
