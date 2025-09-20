"""
NixOS configuration switch script.
"""

import sys
import socket
import argparse
from typing import List
from pathlib import Path

sys.path.append(str(Path(__file__).parent / "util"))
from util.logger import warn
from util.command import call_command
from util.path import repo_root, host_dir


def _confirm_hostname_mismatch(target: str, current: str) -> bool:
    """Ask user for confirmation when target hostname differs from current."""
    warn(f"Target hostname '{target}' differs from current hostname '{current}'")
    print(f"   This will apply configuration for '{target}' to this machine.")
    try:
        response = input("   Continue? (y/N): ").strip()
        return response and response[0] in ["y", "Y"]
    except (KeyboardInterrupt, EOFError):
        print()
        return False


def _get_available_hosts() -> List[str]:
    return list(
        map(lambda p: p.name, filter(lambda e: e.is_dir(), host_dir().iterdir()))
    )


def _switch(hostname: str) -> int:
    current_hostname = socket.gethostname()
    if hostname != current_hostname:
        if not _confirm_hostname_mismatch(hostname, current_hostname):
            print("Aborted.")
            return 1
    cmd = ["nh", "os", "switch", str(repo_root()), "--hostname", hostname]
    return call_command(cmd)


def _main() -> int:
    parser = argparse.ArgumentParser(description="Nixos config switch command")
    parser.add_argument(
        "hostname",
        help=f"Hostname (available: {','.join(_get_available_hosts())})",
        type=str,
    )
    args = parser.parse_args()
    return _switch(args.hostname)


if __name__ == "__main__":
    sys.exit(_main())
