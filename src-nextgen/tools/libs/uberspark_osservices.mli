open Unix
open FilePath
open FileUtilMode

val abspath : string -> bool * string

val mkdir : string -> Unix.file_perm ->  bool * Unix.error * string

val mkdir_v2 :
           ?parent:bool ->
           FilePath.filename ->
           [< `Octal of Unix.file_perm | `Symbolic of FileUtilMode.t ] ->
           unit

val rmdir : string -> unit

val file_copy : string -> string -> unit

val file_remove : string -> unit


val symlink : bool -> string -> string -> unit
    