use std::sync::{Arc, Mutex};
use std::thread;
use std::time::Duration;

struct LoadBalancer {
    servers: Vec<String>,
    index: Mutex<usize>,
}

impl LoadBalancer {
    fn new(servers: Vec<String>) -> Arc<Self> {
        Arc::new(Self {
            servers,
            index: Mutex::new(0),
        })
    }

    fn get_server(&self) -> String {
        let mut index = self.index.lock().unwrap();
        let server = self.servers[*index].clone();
        *index = (*index + 1) % self.servers.len();
        server
    }
}

pub fn run() {
    let lb = LoadBalancer::new(vec![
        "Server1".to_string(),
        "Server2".to_string(),
        "Server3".to_string(),
    ]);

    let lb_clone = lb.clone();
    let handle = thread::spawn(move || {
        for _ in 0..10 {
            let server = lb_clone.get_server();
            println!("Request routed to: {}", server);
            thread::sleep(Duration::from_millis(300));
        }
    });

    handle.join().unwrap();
}
