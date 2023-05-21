open System.Threading.Channels
open System.Threading.Tasks

// mpsc
let channel (numThreads: int) =
    let c: Channel<int> = Channel.CreateUnbounded(UnboundedChannelOptions())
    let r = c.Reader
    let w = c.Writer

    for _ = 1 to numThreads do
        task {
            let! _ = Task.Delay 1000
            w.WriteAsync(1) |> ignore
        }
        |> ignore

    for _ = 1 to numThreads do
        r.ReadAsync().AsTask().Wait()

let stopWatch = System.Diagnostics.Stopwatch.StartNew()
channel (System.Environment.GetCommandLineArgs()[2] |> int)
stopWatch.Stop()
printfn "%fs" stopWatch.Elapsed.TotalMilliseconds
