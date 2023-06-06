def main (argv : List String): IO Unit := do
  let chan <- IO.Channel.new
  let task := (do 
    IO.sleep 1000
    chan.send 1
  )
  let n := argv.head!.toNat!
  let threads := mkArray n (IO.asTask task)
  let r := threads.forM (fun t => do
    let _ <- t
  )
  r
  threads.forM (fun _ => do
    let _ <- chan.sync.recv?
  )
