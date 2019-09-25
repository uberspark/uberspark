open Uberspark

let main () = 
  Uberspark.Logger.log "hello world: %s" Uberspark.Config.env_home_dir;
  ()
;;


main ();;