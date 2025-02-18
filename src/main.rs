// src/main.rs

mod commands; // Import commands module

use clap::{Parser, Subcommand};

#[derive(Parser)]
#[command(name = "cli")]
#[command(about = "A high-performance CLI tool for concurrency, hashing, and load balancing", long_about = None)]
struct Cli {
    #[command(subcommand)]
    command: Commands,
}

#[derive(Subcommand)]
enum Commands {
    /// Run concurrency test
    Concurrency,

    /// Run hash table performance test
    HashTable,

    /// Simulate load balancing
    LoadBalancer,

    /// Install development tools
    InstallTools,
}

fn main() {
    let mac_tweaks = Cli::parse();

    match mac_tweaks.command {
        Commands::Concurrency => commands::concurrency::run(),
        Commands::HashTable => commands::hash_table::run(),
        Commands::LoadBalancer => commands::load_balancer::run(),
        Commands::InstallTools => commands::install_tools::run(),
    }
}
