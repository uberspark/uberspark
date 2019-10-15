open Unix
open FilePath
open FileUtilMode

val abspath : string -> bool * string

val mkdir :
           ?parent:bool ->
           FilePath.filename ->
           [< `Octal of Unix.file_perm | `Symbolic of FileUtilMode.t ] ->
           unit

val rmdir_recurse :
           FilePath.filename list ->
           unit


val rmdir : string -> unit

val file_copy : string -> string -> unit

val file_remove : string -> unit


val symlink : bool -> string -> string -> unit
    
val exec_process_withlog :
           string ->
           string list -> bool -> string -> int * bool * string ref list