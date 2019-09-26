(*module Config = Uberspark_config
module Basetypes = Uberspark_basetypes
*)
(*module Logger = Uberspark_logger*)
(*
module Osservices = Uberspark_osservices
module Manifest = Uberspark_manifest
module Binary = Uberspark_binary
module Uobj = Uberspark_uobj
*)

module Logger : sig
type log_level = None | Stdoutput | Error | Warn | Info | Debug
val ord : log_level -> int
val current_level : int ref
val error_level : int ref
val logf : string -> log_level -> ('a, unit, string, unit) format4 -> 'a
val log :
  ?tag:string ->
  ?stag:string ->
  ?lvl:log_level -> ?crlf:bool -> ('a, unit, string, unit) format4 -> 'a
end