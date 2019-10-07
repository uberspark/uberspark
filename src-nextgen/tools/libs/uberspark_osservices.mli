open Unix

val abspath : string -> bool * string

val mkdir : string -> Unix.file_perm ->  bool * Unix.error * string

val rmdir : string -> unit

val file_copy : string -> string -> unit
