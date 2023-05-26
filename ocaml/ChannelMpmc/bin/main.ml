open Thread
open Event
open Semaphore.Counting

let worker chan sem =
  sync @@ send chan 1;
  delay 1.0 ;
  let _ = sync @@ receive chan in
  release sem

let test n =
  let chan = new_channel () in
  let sem = make 0 in
  for _ = 1 to n do
    let _ = create (fun _ -> worker chan sem) () in
    ()
  done ;
  for _ = 1 to n do
    acquire sem
  done

let () =
  let start = Unix.gettimeofday () in
  let n = int_of_string Sys.argv.(1) in
  test n ;
  let elapsed = Unix.gettimeofday () -. start in
  Printf.printf "%fs\n" elapsed
