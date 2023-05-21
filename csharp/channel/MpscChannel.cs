using System.Threading.Channels;

class MpscChannel
{
    static private async void channel(int numThreads)
    {
        var chan = Channel.CreateUnbounded<int>();
        var reader = chan.Reader;
        var writer = chan.Writer;
        for (var i = 0; i < numThreads; i++)
        {
            Task.Run(async () =>
            {
                await Task.Delay(1000);
                await writer.WriteAsync(1);
            });
        }
        for (var i = 0; i < numThreads; i++)
        {
            reader.ReadAsync().AsTask().Wait();
        }
    }
    static void Main(string[] args)
    {
        var stopWatch = System.Diagnostics.Stopwatch.StartNew();
        var numThreads = 0;
        try
        {
            numThreads = Int32.Parse(args[0]);
        }
        catch (Exception e)
        {
            Console.WriteLine(e);
        }
        channel(numThreads);
        stopWatch.Stop();
        Console.WriteLine($"{stopWatch.Elapsed.TotalMilliseconds / 1000}s");
    }
}