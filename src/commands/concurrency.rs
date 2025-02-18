use rayon::prelude::*;
use std::thread;

pub fn run() {
    println!("Running concurrency test...");

    let data = vec![1, 2, 3, 4, 5];

    data.par_iter().for_each(|x| {
        println!("Processing: {}", x);
        thread::sleep(std::time::Duration::from_millis(500));
    });

    println!("Concurrency test completed.");
}
