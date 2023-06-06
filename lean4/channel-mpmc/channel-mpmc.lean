def main (argv : List String): IO Unit := do
  let chan <- IO.Channel.new
  let task := (do 
    chan.send 1
    IO.sleep 1000
    let _ <- chan.sync.recv?
  )
  let n := argv.head!.toNat!
  let threads := mkArray n (IO.asTask task)
  let ts := threads.foldlM (fun β α => do 
    let a <- α 
    return List.cons a β) List.nil
  let ts <- ts
  let _ <- ts.forM ( do
    let _ := Task.get ·  
  )
