"""
VM run on QEMU
"""

import sys
import argparse
from typing import List
from pathlib import Path

sys.path.append(str(Path(__file__).parent / "util"))
from util.command import call_command
from util.path import vm_dir, get_vm_image
from util.logger import error, log


def _get_available_vms() -> List[str]:
    return list(
        map(lambda p: p.stem, filter(lambda e: e.is_file(), vm_dir().iterdir()))
    )


def _run_vm(hostname: str, unknown_args: List[str]) -> int:
    qcow_path = get_vm_image(hostname)
    if not qcow_path.exists():
        error(f"VM image not found: {qcow_path}")
        print("   Run 'vm-cleanbuild {hostname}' first")
        return 1
    log(f"Starting VM: {hostname}")
    cmd = [
        "qemu-kvm",
        "-hda",
        str(qcow_path),
    ] + unknown_args
    return call_command(cmd)


def _main() -> int:
    parser = argparse.ArgumentParser(description="VM management utilities")
    parser.add_argument(
        "hostname",
        help=f"VM hostname (available: {','.join(_get_available_vms())})",
        type=str,
    )
    known_args, unknown_args = parser.parse_known_args()
    log(f"args: {known_args}, {unknown_args}")
    return _run_vm(known_args.hostname, unknown_args)


if __name__ == "__main__":
    sys.exit(_main())
