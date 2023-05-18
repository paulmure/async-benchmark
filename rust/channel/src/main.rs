use async_io::Timer;
use clap::Parser;
use smol::spawn;
use std::sync::mpsc;
use std::sync::mpsc::{Receiver, Sender};
use std::time::{Duration, SystemTime};

#[derive(Parser)]
struct Cli {
    num_threads: i32,
}

async fn wait_inc(c: Sender<i32>) {
    Timer::after(Duration::from_secs(1)).await;
    c.send(1).unwrap();
}

fn main() {
    let start = SystemTime::now();
    smol::block_on(async {
        let args = Cli::parse();
        let (tx, rx): (Sender<i32>, Receiver<i32>) = mpsc::channel();

        for _ in 0..args.num_threads {
            spawn(wait_inc(tx.clone())).detach();
        }

        let mut cum: i32 = 0;
        loop {
            cum += rx.recv().unwrap();
            if cum == args.num_threads {
                break;
            }
        }
    });
    let end = SystemTime::now();
    let duration = end.duration_since(start).unwrap();
    println!("{}", duration.as_secs_f64());
}
