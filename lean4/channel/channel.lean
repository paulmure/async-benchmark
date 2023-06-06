def main (argv : List String): IO Unit := do
  let chan <- IO.Channel.new
  let task := (do 
    IO.sleep 1000
    chan.send 1
  )
  let n := argv.head!.toNat!
  for _ in mkArray n 0 do 
    let _ <- IO.asTask task
  for _ in mkArray n 0 do 
    let _ <- chan.sync.recv?
