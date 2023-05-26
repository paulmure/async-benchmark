open Thread
open Event

let worker chan =
  delay 1.0 ;
  let _ = send chan 1 in
  ()

let test n =
  let chan = new_channel () in
  for _ = 1 to n do
    let _ = create (fun _ -> worker chan) () in
    ()
  done ;
  for _ = 1 to n do
    let _ = receive chan in ()
  done

let () =
  let start = Unix.gettimeofday () in
  let n = int_of_string Sys.argv.(1) in
  test n ;
  let elapsed = Unix.gettimeofday () -. start in
  Printf.printf "%fs\n" elapsed
