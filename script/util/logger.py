#!/usr/bin/env python3
"""
Simple print-based logging utility for NixOS configuration scripts.
"""

import datetime


class Colors:
    RED = "\033[0;31m"
    GREEN = "\033[0;32m"
    YELLOW = "\033[1;33m"
    BLUE = "\033[0;34m"
    NC = "\033[0m"  # No Color


def log(message: str) -> None:
    """Print an informational message with timestamp."""
    timestamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    print(f"{Colors.BLUE}[{timestamp}] {message}{Colors.NC}")


def error(message: str) -> None:
    """Print an error message."""
    timestamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    print(f"{Colors.RED}[{timestamp}] [ERROR] {message}{Colors.NC}")


def warn(message: str) -> None:
    """Print a warning message."""
    timestamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    print(f"{Colors.YELLOW}[{timestamp}] [WARN] {message}{Colors.NC}")


def success(message: str) -> None:
    """Print a success message."""
    timestamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    print(f"{Colors.GREEN}[{timestamp}] [SUCCESS] {message}{Colors.NC}")


def debug(message: str) -> None:
    """Print a debug message."""
    timestamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    print(f"{Colors.BLUE}[{timestamp}] [DEBUG] {message}{Colors.NC}")


if __name__ == "__main__":
    log("This is an info message")
    warn("This is a warning")
    error("This is an error")
    success("This is a success message")
    debug("This is a debug message")