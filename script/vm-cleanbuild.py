"""
VM clean-build command
"""

import sys
import os
import argparse
from typing import List
from pathlib import Path

sys.path.append(str(Path(__file__).parent / "util"))
from util.path import vm_dir, repo_root, vm_result_dir, get_vm_image
from util.logger import log, success
from util.command import call_command


def _get_available_vms() -> List[str]:
    return list(
        map(lambda p: p.stem, filter(lambda e: e.is_file(), vm_dir().iterdir()))
    )


def _build_vm(hostname: str, size: str) -> int:
    log(f"Building VM image for {hostname}...")
    repo_path = repo_root()
    ret = call_command(["nix", "build", f"{repo_path}#{hostname}"])
    if ret != 0:
        return ret

    log("Setting up VM result directory...")
    vm_result_path = vm_result_dir()
    vm_result_path.mkdir(parents=True, exist_ok=True)

    log("Copying QCOW2 image...")
    qcow_path = get_vm_image(hostname)
    result_image = repo_path / "result" / "nixos.qcow2"
    ret = call_command(["cp", "-f", str(result_image), str(qcow_path)])
    if ret != 0:
        return ret
    os.chmod(qcow_path, 0o644)

    log(f"Resizing image to {size}...")
    ret = call_command(["qemu-img", "resize", str(qcow_path), size])
    if ret != 0:
        return ret

    success(f"VM image built successfully: {qcow_path} ({size})")
    return 0


def _main() -> int:
    parser = argparse.ArgumentParser(description="VM build")
    parser.add_argument(
        "hostname",
        help=f"VM hostname (available: {','.join(_get_available_vms())})",
        type=str,
    )
    parser.add_argument(
        "--size", default="128G", help="Disk size (default: 128G)", type=str
    )
    args = parser.parse_args()
    return _build_vm(args.hostname, args.size)


if __name__ == "__main__":
    sys.exit(_main())
