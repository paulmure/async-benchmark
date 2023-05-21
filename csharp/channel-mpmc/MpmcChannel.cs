using System.Threading.Channels;
using System.Threading.Tasks;

class MpmcChannel
{
    static private async void channel(int numThreads)
    {
        var chan = Channel.CreateUnbounded<int>();
        var reader = chan.Reader;
        var writer = chan.Writer;
        var tasks = new Task[numThreads];
        for (var i = 0; i < numThreads; i++)
        {
            tasks[i] = Task.Run(async () =>
            {
                await writer.WriteAsync(1);
                await Task.Delay(1000);
                await reader.ReadAsync();
            });
        }
        Task.WaitAll(tasks);
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