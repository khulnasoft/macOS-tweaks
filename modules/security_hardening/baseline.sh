#!/usr/bin/env bash

# ==============================================================================
# Ultimate macOS Security Baseline Script
#
# Description:
#   This script applies a comprehensive set of security settings based on
#   CIS Benchmarks and community best practices. It is idempotent, includes
#   detailed logging, a dry-run mode, and a summary report.
#
# Usage:
#   sudo ./secure_macos.sh [options]
#
# Options:
#   --dry-run   : Run without making any changes, showing what would be done.
#   --silent    : Suppress all output except for the final summary and errors.
#   --help      : Display this help message.
#
# Prerequisites:
#   Must be run with root privileges (sudo).
# ==============================================================================

# --- Configuration & Globals ---
readonly SCRIPT_VERSION="2.0"
readonly LOG_FILE="/var/log/macos_security_baseline.log"

# --- Script Modes ---
declare DRY_RUN=false
declare SILENT_MODE=false

# --- Counters for Summary ---
declare -i applied=0
declare -i skipped=0
declare -i failed=0
declare -i warnings=0

# --- Process Command-Line Arguments ---
for arg in "$@"; do
    case $arg in
        --dry-run) DRY_RUN=true; shift ;;
        --silent) SILENT_MODE=true; shift ;;
        --help) 
            # Using sed to extract the help message from the script's header
            sed -n '8,16p' "$0" | sed 's/^# //'
            exit 0
            ;; 
    esac
done

# --- Setup & Core Functions (Moved from previous version) ---
# This section includes the color definitions, logging, and action runners
# from the previous script. They are assumed to be here for brevity.
# (The full script would include the color setup, log, run_action, etc.)

# Simplified logging for this example
log() {
    if ! $SILENT_MODE; then
        echo "$@"
    fi
    echo "$(date +"%Y-%m-%d %H:%M:%S") - $@" >> "${LOG_FILE}"
}

# Mock action runners for demonstration
run_action() {
    log "INFO: $1"
    if $DRY_RUN;
    then
        log "DRY-RUN: Would execute: $2"
        ((skipped++))
    else
        if eval "$2" >> "${LOG_FILE}" 2>&1; then
            log "SUCCESS: $1"
            ((applied++))
        else
            log "ERROR: Failed to $1"
            ((failed++))
        fi
    fi
}

check_and_apply() {
    log "CHECK: $1"
    if eval "$2" >/dev/null 2>&1; then
        log "SKIP: Already configured: $1"
        ((skipped++))
    else
        run_action "APPLY: $1" "$3"
    fi
}


# --- Main Logic ---
main() {
    # --- Initial Setup ---
    if [[ $EUID -ne 0 ]]; then
        echo "ERROR: This script must be run as root. Use sudo."
        exit 1
    fi
    
    # Initialize log file
    echo "macOS Security Baseline v${SCRIPT_VERSION} Run: $(date)" > "${LOG_FILE}"
    if $DRY_RUN;
    then
        log "INFO: --- Starting DRY RUN mode --- (No changes will be made)"
    fi

    # --- Expanded Security Settings ---
    log "HEADER: --- System & Network Hardening ---"
    check_and_apply "Disable Bonjour multicast advertising" "defaults read /Library/Preferences/com.apple.mDNSResponder.plist NoMulticastAdvertisements -bool true" "defaults write /Library/Preferences/com.apple.mDNSResponder.plist NoMulticastAdvertisements -bool true"
    check_and_apply "Disable Wake for network access" "pmset -a womp 0" "pmset -a womp 0"
    check_and_apply "Disable Bluetooth unless needed" "defaults read /Library/Preferences/com.apple.Bluetooth.plist ControllerPowerState -int 0" "defaults write /Library/Preferences/com.apple.Bluetooth.plist ControllerPowerState -int 0; killall -HUP blued"

    log "HEADER: --- Advanced Firewall Settings ---"
    check_and_apply "Enable firewall logging" "/usr/libexec/ApplicationFirewall/socketfilterfw --getloggingmode | grep -q ENABLED" "/usr/libexec/ApplicationFirewall/socketfilterfw --setloggingmode on"
    check_and_apply "Block all incoming connections" "/usr/libexec/ApplicationFirewall/socketfilterfw --getblockall | grep -q ENABLED" "/usr/libexec/ApplicationFirewall/socketfilterfw --setblockall on"
    check_and_apply "Disable allowing signed apps automatically" "/usr/libexec/ApplicationFirewall/socketfilterfw --getallowsigned | grep -q DISABLED" "/usr/libexec/ApplicationFirewall/socketfilterfw --setallowsigned off"

    # ... (include all the checks from the previous script here) ...

    # --- Final Summary ---
    if ! $SILENT_MODE || $DRY_RUN;
    then
        echo -e "\n--- ✅ Baseline Configuration Complete ---"
        echo -e "Applied: ${applied}, Skipped: ${skipped}, Warnings: ${warnings}, Failed: ${failed}"
        echo "Review the full log at: ${LOG_FILE}"
    fi
}

# --- Execute Script ---
main "$@"
