import asyncio
from asyncio import Queue, Task
import sys
import time
from typing import List


async def worker(queue: Queue):
    await asyncio.sleep(1)
    await queue.put(1)


async def do_work(num_workers: int):
    queue = Queue()
    workers: List[Task] = []
    for _ in range(num_workers):
        workers.append(asyncio.create_task(worker(queue)))
    for _ in range(num_workers):
        await queue.get()


def main():
    num_workers = int(sys.argv[1])
    start = time.time()
    asyncio.run(do_work(num_workers))
    print(f"{time.time() - start} s")


if __name__ == "__main__":
    main()
