open System.Threading.Channels
open System.Threading.Tasks

// mpsc
let channel (numThreads: int) =
    let c: Channel<int> = Channel.CreateUnbounded(UnboundedChannelOptions())
    let r = c.Reader
    let w = c.Writer

    Task.WaitAll(
        [| for _ in 1..numThreads ->
               task {
                   let! _ = w.WriteAsync(1).AsTask()
                   let! _ = Task.Delay 1000
                   r.ReadAsync() |> ignore
               } |]: Task array
    )

let stopWatch = System.Diagnostics.Stopwatch.StartNew()
channel (System.Environment.GetCommandLineArgs()[2] |> int)
stopWatch.Stop()
printfn "%fs" (stopWatch.Elapsed.TotalMilliseconds / 1000.0)
