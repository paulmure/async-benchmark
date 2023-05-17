import os
import sys
import time
import matplotlib.pyplot as plt

file_path = os.path.realpath(__file__)
cwd = os.path.dirname(file_path)

n = int(sys.argv[1])

def test_go(num_threads):
    start = time.time()
    os.system(f'{cwd}/go/go -numThreads {num_threads}')
    return time.time() - start


def test_rust(num_threads):
    start = time.time()
    os.system(f'{cwd}/rust/target/release/rust {num_threads}')
    return time.time() - start


thread_counts = []
go_times = []
rust_times = []

for i in range(n):
    exp = i + 1
    thread_count = 10**exp
    thread_counts.append(thread_count)
    print(f'Testing {thread_count} threads...')

    go_time = test_go(thread_count)
    go_times.append(go_time)
    print(f'Go took {go_time} seconds')

    rust_time = test_rust(thread_count)
    rust_times.append(rust_time)
    print(f'Rust took {rust_time} seconds')

    print()

plt.xlabel('Thread Count')
plt.ylabel('Runtime (seconds)')
plt.title('Async Benchmark')

plt.plot(thread_counts, go_times, color='blue', label="Go")
plt.plot(thread_counts, rust_times, color='orange', label="Rust")

plt.legend()
plt.savefig('runtime.png')
