use libc::{mmap, munmap, MAP_ANONYMOUS, MAP_PRIVATE, PROT_READ, PROT_WRITE};
use std::ptr;

pub fn allocate_memory(size: usize) -> *mut u8 {
    unsafe {
        let ptr = mmap(
            ptr::null_mut(),
            size,
            PROT_READ | PROT_WRITE,
            MAP_PRIVATE | MAP_ANONYMOUS,
            -1,
            0,
        );

        if ptr == libc::MAP_FAILED {
            panic!("Failed to allocate memory using mmap!");
        }

        println!("Memory allocated successfully: {} bytes", size);
        ptr as *mut u8
    }
}

pub fn free_memory(ptr: *mut u8, size: usize) {
    unsafe {
        munmap(ptr as *mut libc::c_void, size);
        println!("Memory deallocated.");
    }
}
