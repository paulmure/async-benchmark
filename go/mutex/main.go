package main

import (
	"flag"
	"fmt"
	"sync"
	"time"
)

type Counter struct {
	mu  sync.Mutex
	ctr int
}

func (c *Counter) WaitInc() {
	time.Sleep(1 * time.Second)

	c.mu.Lock()
	defer c.mu.Unlock()

	c.ctr++
}

func main() {
	numThreads := flag.Int("numThreads", 100, "Number of async \"threads\" to use")
	flag.Parse()

	start_time := time.Now()

	ctr := Counter{ctr: 0}
	var wg sync.WaitGroup

	for i := 0; i < *numThreads; i++ {
		wg.Add(1)
		go func() {
			defer wg.Done()
			ctr.WaitInc()
		}()
	}

	wg.Wait()

	if ctr.ctr != *numThreads {
		panic("Counter mismatch!")
	}

	duration := time.Since(start_time)
	fmt.Println(duration.Seconds())
}
