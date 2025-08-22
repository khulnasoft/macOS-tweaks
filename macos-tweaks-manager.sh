#!/bin/bash

# macOS Tweaks Manager v2.1 (Polished)
# A centralized, feature-rich, and dynamic management script.

# --- Shell Settings ---
set -euo pipefail

# --- Script Directory ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# --- Script Flags ---
STRICT_MODE=false
DRY_RUN=false

# --- Configuration ---
CONFIG_FILE="modules.json"
LOG_FILE="manager.log"
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"

# --- Colors ---
RESET='[0m'; BOLD='[1m'; RED='[0;31m'; GREEN='[0;32m';
YELLOW='[0;33m'; BLUE='[0;34m'; CYAN='[0;36m';

# --- Logging ---
log() { echo -e "$1" | tee -a "$LOG_FILE"; }
info() { log "${CYAN}INFO: $1${RESET}"; }
success() { log "${GREEN}SUCCESS: $1${RESET}"; }
error() { log "${RED}ERROR: $1${RESET}"; }
warn() { log "${YELLOW}WARNING: $1${RESET}"; }

# --- Helper Functions ---
print_header() {
    clear
    echo -e "${BLUE}========================================${RESET}"
    echo -e "${BLUE}  ${BOLD}macOS Tweaks Manager${RESET}${BLUE}"
    echo -e "${BLUE}========================================${RESET}"
}

usage() {
    print_header
    echo
    echo -e "${BOLD}Usage:${RESET}"
    echo "  ./macos-tweaks-manager.sh [OPTIONS]"
    echo
    echo -e "${BOLD}OPTIONS:${RESET}"
    echo "  -s, --strict    Exit immediately if a script fails."
    echo "  -d, --dry-run   Print commands without executing them."
    echo "  -h, --help      Display this help message."
    echo
}

# --- Core Logic ---

# Checks for required dependencies (jq) and validates the config file.
check_dependencies() {
    if ! command -v jq &> /dev/null; then
        error "'jq' is not installed. Please run 'brew install jq'."
        exit 1
    fi
    if [ ! -f "$CONFIG_FILE" ]; then
        error "Configuration file not found: $CONFIG_FILE"
        exit 1
    fi
    if ! jq . "$CONFIG_FILE" >/dev/null 2>&1; then
        error "Configuration file is not valid JSON: $CONFIG_FILE"
        exit 1
    fi
}

# Retrieves a module object from JSON and executes its scripts.
run_module() {
    local module_index=$(( $1 - 1 ))
    local module_obj; module_obj=$(jq ".modules[${module_index}]" "$CONFIG_FILE")
    local module_name; module_name=$(jq -r '.name' <<< "$module_obj")

    info "Preparing to run module: ${BOLD}${module_name}${RESET}"

    local scripts; scripts=($(jq -r '.scripts[]' <<< "$module_obj"))
    echo "This module will execute the following scripts:"
    for s in "${scripts[@]}"; do echo "  - $s"; done

    read -rp "Continue? (y/N): " confirm
    if [[ ! "$confirm" =~ ^[yY](es)?$ ]]; then
        warn "Module execution cancelled."
        return
    fi

    for script in "${scripts[@]}"; do
        if [[ ! -f "$script" ]]; then
            error "Script not found: $script"
            continue
        fi
        info "Executing $script..."
        if [ "$DRY_RUN" = true ]; then
            warn "[DRY RUN] Would execute: bash $script"
        else
            # Execute and check the exit code, while logging both stdout and stderr
            if bash "$script" 2>&1 | tee -a "$LOG_FILE"; then
                success "$script completed."
            else
                error "$script failed."
                if [ "$STRICT_MODE" = true ]; then
                    error "Strict mode is enabled. Aborting."
                    exit 1
                fi
            fi
        fi
    done
}

# --- Menu Actions ---

# Displays the main menu of selectable modules.
display_menu() {
    echo
    info "Please select an option:"
    # Pretty-print the menu with names and descriptions
    jq -r '.modules[] | "  (.name) - (.description)"' "$CONFIG_FILE" | nl -w4 -s'. '
    echo
    echo " --- Actions ---"
    echo " H. Help for a Module"
    echo " S. System Information"
    echo " C. Clean Orphaned Directories"
    echo " U. Update All Tools"
    echo " Q. Exit"
    echo
}

# Shows the detailed help content for a user-selected module.
show_module_help() {
    read -rp "Enter the number of the module to get help for: " choice
    local module_count; module_count=$(jq '.modules | length' "$CONFIG_FILE")
    if ! [[ "$choice" =~ ^[0-9]+$ ]] || [ "$choice" -lt 1 ] || [ "$choice" -gt "$module_count" ]; then
        error "Invalid module number."
        return
    fi

    local module_index=$(( $choice - 1 ))
    local module_obj; module_obj=$(jq ".modules[${module_index}]" "$CONFIG_FILE")
    local help_file; help_file=$(jq -r '.help_file' <<< "$module_obj")

    if [[ -f "$help_file" ]];
    then
        echo "--- Help for $(jq -r '.name' <<< "$module_obj") ---"
        cat "$help_file"
        echo "--------------------"
    else
        warn "No help file found for this module."
    fi
}

# Displays a summary of key system information.
show_system_info() {
    info "System Information:"
    echo " - OS Version: $(sw_vers -productVersion)"
    echo " - Kernel: $(uname -r)"
    echo " - Hostname: $(hostname)"
    echo " - Uptime: $(uptime)"
}

# Finds and offers to delete directories from the old project structure.
clean_orphaned_dirs() {
    info "Checking for potentially orphaned directories..."
    local old_dirs=("Blackhat-MacOS-Config" "MacOS-Security-Baseline" "MacOS-Config" "MacOS-Maid" "randomMAC")
    local found_dirs=()
    for dir in "${old_dirs[@]}"; do
        if [ -d "$dir" ]; then
            found_dirs+=("$dir")
        fi
    done

    if [ ${#found_dirs[@]} -eq 0 ]; then
        success "No orphaned directories found."
        return
    fi

    warn "Found potentially orphaned directories:"
    for dir in "${found_dirs[@]}"; do echo "  - $dir"; done

    read -rp "Delete them? THIS IS PERMANENT. (y/N): " confirm
    if [[ "$confirm" =~ ^[yY](es)?$ ]]; then
        for dir in "${found_dirs[@]}"; do
            info "Deleting $dir..."
            rm -rf "$dir"
        done
        success "Cleanup complete."
    else
        warn "Cleanup cancelled."
    fi
}

# Pulls the latest git changes and updates Homebrew.
update_tools() {
    info "Updating all tools..."
    git pull --ff-only
    brew update && brew upgrade
    success "Update complete."
}

# --- Main Execution ---

# Main function to orchestrate the script execution.
main() {
    # Parse command-line arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -s|--strict) STRICT_MODE=true; shift ;;
            -d|--dry-run) DRY_RUN=true; shift ;;
            -h|--help) usage; exit 0 ;;
            *) echo "Unknown option: $1"; usage; exit 1 ;;
        esac
    done

    check_dependencies
    info "Log file started at $LOG_FILE"
    if [ "$STRICT_MODE" = true ]; then warn "Running in Strict Mode."; fi
    if [ "$DRY_RUN" = true ]; then warn "Running in Dry Run Mode."; fi

    local module_count; module_count=$(jq '.modules | length' "$CONFIG_FILE")

    while true; do
        print_header
        display_menu
        read -rp "Enter your choice: " choice
        echo "----------------------------------------"

        if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le "$module_count" ]; then
            run_module "$choice"
        else
            case "$choice" in
                [hH]) show_module_help ;;
                [sS]) show_system_info ;;
                [cC]) clean_orphaned_dirs ;;
                [uU]) update_tools ;;
                [qQ]) info "Exiting."; exit 0 ;;
                *) error "Invalid option." ;;
            esac
        fi
        echo "----------------------------------------"
        read -rp "Press Enter to return to the menu..."
    done
}

# Run the main function with all provided script arguments
main "$@"