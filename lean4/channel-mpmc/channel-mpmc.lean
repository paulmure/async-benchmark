def main (argv : List String): IO Unit := do
  let chan <- IO.Channel.new
  let task := (do 
    chan.send 1
    IO.sleep 1000
    let _ <- chan.sync.recv?
  )
  let n := argv.head!.toNat!
  let threads := mkArray n (IO.asTask task)
  let r := threads.forM (fun t => do
    let q <- t
    let _ := Task.get q
  )
  r
