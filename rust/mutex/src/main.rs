use clap::Parser;
use futures::future::join_all;

// Smol version
use async_io::Timer;
use smol::lock::Mutex;
use smol::spawn;
use std::sync::Arc;
use std::time::{Duration, SystemTime};

// Tokio version
// use std::sync::Arc;
// use tokio::{
//     spawn,
//     sync::Mutex,
//     time::{sleep, Duration},
// };

// Async_std version
// use async_std::{
//     sync::{Arc, Mutex},
//     task::{sleep, spawn},
// };
// use std::time::Duration;

#[derive(Parser)]
struct Cli {
    num_threads: i32,
}

async fn wait_inc(ctr: Arc<Mutex<i32>>) {
    // not smol
    // sleep(Duration::from_secs(1)).await;

    // // smol
    Timer::after(Duration::from_secs(1)).await;

    // tokio
    // let mut num = ctr.lock().await;

    // smol and async_std
    let mut num = ctr.lock_arc().await;

    *num += 1;
}

// #[async_std::main]
// // #[tokio::main]
// async fn main() {
//     let args = Cli::parse();
//     let counter = Arc::new(Mutex::new(0));
//     let mut handles = vec![];

//     for _ in 0..args.num_threads {
//         handles.push(spawn(wait_inc(counter.clone())));
//     }

//     join_all(handles).await;

//     {
//         // tokio
//         // let num = counter.lock().await;

//         // async_std
//         let num = counter.lock_arc().await;

//         assert_eq!(*num, args.num_threads);
//     }
// }

fn main() {
    let start = SystemTime::now();
    smol::block_on(async {
        let args = Cli::parse();
        let counter = Arc::new(Mutex::new(0));
        let mut handles = vec![];

        for _ in 0..args.num_threads {
            handles.push(spawn(wait_inc(counter.clone())));
        }

        join_all(handles).await;

        {
            let num = counter.lock_arc().await;
            assert_eq!(*num, args.num_threads);
        }
    });
    let end = SystemTime::now();
    let duration = end.duration_since(start).unwrap();
    println!("{}", duration.as_secs_f64());
}
