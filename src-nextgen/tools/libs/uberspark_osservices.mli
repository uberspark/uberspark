open Unix
open FilePath
open FileUtilMode

val abspath : string -> bool * string

val mkdir :
           ?parent:bool ->
           FilePath.filename ->
           [< `Octal of Unix.file_perm | `Symbolic of FileUtilMode.t ] ->
           unit

val dir_change : string -> bool * string * string


val rmdir_recurse :
           FilePath.filename list ->
           unit


val rmdir : string -> unit

val getcurdir : unit -> string

val file_copy : string -> string -> unit

val cp  : ?recurse:bool -> ?force:bool -> string -> string -> unit


val file_remove : string -> unit


val symlink : bool -> string -> string -> unit
    
val readlink : string -> string
    
val exec_process_withlog : 
           ?log_lvl:Uberspark_logger.log_level -> 
           ?stag:string -> 
           string ->
           string list -> int * bool * string ref list