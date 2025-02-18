// src/commands/install_tools.rs

use std::process::Command;

pub fn run() {
    let tools = [
        "ack",
        "aircrack-ng",
        "bash",
        "bash-completion2",
        "bfg",
        "binutils",
        "binwalk",
        "cifer",
        "coreutils",
        "dark-mode",
        "dex2jar",
        "dns2tcp",
        "fcrackzip",
        "findutils",
        "foremost",
        "git",
        "git-lfs",
        "gnu-sed",
        "grep",
        "hashpump",
        "hydra",
        "imagemagick",
        "john",
        "knock",
        "lua",
        "lynx",
        "netpbm",
        "nmap",
        "openssh",
        "p7zip",
        "pigz",
        "pngcheck",
        "pv",
        "rename",
        "rlwrap",
        "screen",
        "shellcheck",
        "socat",
        "sqlmap",
        "ssh-copy-id",
        "tcpflow",
        "tcpreplay",
        "tcptrace",
        "tree",
        "ucspi-tcp",
        "vbindiff",
        "vim",
        "wget",
        "xpdf",
        "xz",
        "zopfli",
        "rust",
    ];

    // Install each tool using `brew`
    for tool in tools.iter() {
        let status = Command::new("brew").arg("install").arg(tool).status();

        match status {
            Ok(status) if status.success() => println!("Successfully installed: {}", tool),
            Ok(_) => eprintln!("Failed to install: {}", tool),
            Err(err) => eprintln!("Error installing {}: {}", tool, err),
        }
    }

    // Clean up brew after installation
    let status = Command::new("brew").arg("cleanup").status();

    match status {
        Ok(status) if status.success() => println!("Brew cleanup completed."),
        Ok(_) => eprintln!("Brew cleanup failed."),
        Err(err) => eprintln!("Error running brew cleanup: {}", err),
    }
}
