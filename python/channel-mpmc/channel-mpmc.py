import asyncio
from asyncio import Queue, Task
import sys
import time
from typing import List


async def worker(queue: Queue):
    await queue.put(1)
    await asyncio.sleep(1)
    await queue.get()


async def do_work(num_workers: int):
    queue = Queue()
    workers: List[Task] = []
    for _ in range(num_workers):
        workers.append(asyncio.create_task(worker(queue)))
    for t in workers:
        await t


def main():
    num_workers = int(sys.argv[1])
    start = time.time()
    asyncio.run(do_work(num_workers))
    print(f"{time.time() - start} s")


if __name__ == "__main__":
    main()
