package main

import (
	"flag"
	"fmt"
	"sync"
	"time"
)

func main() {
	numThreads := flag.Int("numThreads", 100, "Number of async \"threads\" to use")
	flag.Parse()

	start_time := time.Now()

	c := make(chan int, *numThreads)

	var wg sync.WaitGroup
	wg.Add(*numThreads)

	for i := 0; i < *numThreads; i++ {
		go func() {
			c <- 1
			time.Sleep(1 * time.Second)
			<-c
			wg.Done()
		}()
	}

	wg.Wait()

	duration := time.Since(start_time)
	fmt.Println(duration.Seconds())
}
