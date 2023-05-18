import os
import sys
import pandas as pd

BENCHMARK = 'channel'
# BENCHMARK = 'mutex'

file_path = os.path.realpath(__file__)
cwd = os.path.dirname(file_path)

n = int(sys.argv[1])


def parse_runtime(cmd):
    out = os.popen(cmd).read()
    return float(out)


def test_go(num_threads):
    return parse_runtime(f'{cwd}/go/{BENCHMARK}/{BENCHMARK} -numThreads {num_threads}')


def test_rust(num_threads):
    return parse_runtime(f'{cwd}/rust/{BENCHMARK}/target/release/{BENCHMARK} {num_threads}')


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

df = pd.DataFrame()

df['ThreadCount'] = thread_counts
df['Go'] = go_times
df['Rust'] = rust_times

df.to_csv('data.csv')