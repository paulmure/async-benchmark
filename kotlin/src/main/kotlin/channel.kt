import kotlinx.coroutines.runBlocking
import kotlinx.coroutines.launch
import kotlinx.coroutines.delay
import kotlinx.coroutines.channels.Channel

fun main(args: Array<String>) {
    val numThreads = args[0].toInt()
    val start = System.currentTimeMillis()

    val channel = Channel<Int>(Channel.UNLIMITED)
    runBlocking {
        repeat(numThreads) {
            launch {
                delay(1000)
                channel.send(1)
            }
        }
        repeat(numThreads) {
            channel.receive()
        }
    }

    println("${(System.currentTimeMillis() - start).toDouble() / 1000}s")
}