use async_io::Timer;
use clap::Parser;
use crossbeam::channel::{unbounded, Receiver, Sender};
use futures::future::join_all;
use smol::spawn;
use std::time::{Duration, SystemTime};

#[derive(Parser)]
struct Cli {
    num_threads: i32,
}

async fn wait_inc(tx: Sender<i32>, rx: Receiver<i32>) {
    tx.send(1).unwrap();
    Timer::after(Duration::from_secs(1)).await;
    assert_eq!(rx.recv().unwrap(), 1);
}

fn main() {
    let start = SystemTime::now();
    smol::block_on({
        let args = Cli::parse();
        let (tx, rx): (Sender<i32>, Receiver<i32>) = unbounded();
        let mut handles = vec![];

        for _ in 0..args.num_threads {
            handles.push(spawn(wait_inc(tx.clone(), rx.clone())));
        }

        join_all(handles)
    });
    let end = SystemTime::now();
    let duration = end.duration_since(start).unwrap();
    println!("{}", duration.as_secs_f64());
}
