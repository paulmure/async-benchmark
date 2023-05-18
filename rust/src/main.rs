use clap::Parser;
use std::sync::Arc;
use tokio::{
    spawn,
    sync::Mutex,
    time::{sleep, Duration},
};

#[derive(Parser)]
struct Cli {
    num_threads: i32,
}

async fn wait_inc(ctr: Arc<Mutex<i32>>) {
    sleep(Duration::from_secs(1)).await;
    let mut num = ctr.lock().await;
    *num += 1;
}

#[tokio::main]
async fn main() {
    let args = Cli::parse();
    let counter = Arc::new(Mutex::new(0));
    let mut handles = vec![];

    for _ in 0..args.num_threads {
        handles.push(spawn(wait_inc(counter.clone())))
    }

    futures::future::join_all(handles).await;

    {
        let num = counter.lock().await;
        assert_eq!(*num, args.num_threads);
    }
}
