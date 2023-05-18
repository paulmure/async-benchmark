package main

import (
	"flag"
	"fmt"
	"time"
)

func WaitInc(c chan int) {
	time.Sleep(1 * time.Second)
	c <- 1
}

func main() {
	numThreads := flag.Int("numThreads", 100, "Number of async \"threads\" to use")
	flag.Parse()

	start_time := time.Now()

	c := make(chan int)

	for i := 0; i < *numThreads; i++ {
		go WaitInc(c)
	}

	cum := 0

	for {
		recv := <-c
		cum += recv
		if cum == *numThreads {
			break
		}
	}

	duration := time.Since(start_time)
	fmt.Println(duration.Seconds())
}
