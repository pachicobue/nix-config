"""
NixOS configuration switch script.
"""

import sys
import argparse
from typing import List
from pathlib import Path

sys.path.append(str(Path(__file__).parent / "util"))
from util.command import call_command
from util.path import repo_root, host_dir


def _get_available_hosts() -> List[str]:
    return list(
        map(lambda p: p.name, filter(lambda e: e.is_dir(), host_dir().iterdir()))
    )


def _switch(hostname: str, remote: str | None) -> int:
    cmd = ["nh", "os", "switch", str(repo_root()), "--hostname", hostname]
    if remote is not None:
        ssh_target = remote if remote else f"root@{hostname}"
        cmd += ["--target-host", ssh_target]
    return call_command(cmd)


def _main() -> int:
    parser = argparse.ArgumentParser(description="NixOS + home-manager switch command")
    parser.add_argument(
        "hostname",
        help=f"Hostname (available: {','.join(_get_available_hosts())})",
        type=str,
    )
    parser.add_argument(
        "--remote",
        nargs="?",
        const="",
        default=None,
        metavar="SSH_TARGET",
        help="Deploy remotely. SSH target defaults to root@<hostname>",
    )
    args = parser.parse_args()
    return _switch(args.hostname, args.remote)


if __name__ == "__main__":
    sys.exit(_main())
