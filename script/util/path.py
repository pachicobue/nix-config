"""
Repository path utilities.
Provides easy access to repository structure and absolute paths.
"""

import os
from pathlib import Path
from typing import Optional


def find_repo_root(start_path: Optional[str] = None) -> Path:
    """
    Find the repository root by looking for flake.nix file.

    Args:
        start_path: Directory to start searching from. Defaults to current script location.

    Returns:
        Path to repository root

    Raises:
        RuntimeError: If repository root cannot be found
    """
    if start_path is None:
        # Start from the directory containing this script
        start_path = os.path.dirname(os.path.abspath(__file__))

    current_path = Path(start_path).resolve()

    # Look for flake.nix in current directory and parents
    while current_path != current_path.parent:
        flake_file = current_path / "flake.nix"
        if flake_file.exists():
            return current_path
        current_path = current_path.parent

    raise RuntimeError("Could not find nix-config repository root (no flake.nix found)")


def repo_root() -> Path:
    """Get the absolute path to the repository root."""
    return find_repo_root()


def script_dir() -> Path:
    """Get the absolute path to the script/ directory."""
    return repo_root() / "script"


def host_dir() -> Path:
    """Get the absolute path to the host/ directory."""
    return repo_root() / "host"


def module_dir() -> Path:
    """Get the absolute path to the module/ directory."""
    return repo_root() / "module"


def vm_dir() -> Path:
    """Get the absolute path to the vm/ directory."""
    return repo_root() / "vm"


def vm_result_dir() -> Path:
    """Get the absolute path to the vm/result/ directory."""
    return repo_root() / "vm" / "result"


def get_vm_image(hostname: str) -> Path:
    """Get the absolute path to a VM image file."""
    return vm_result_dir() / f"{hostname}.qcow2"


def get_host_config(hostname: str) -> Path:
    """Get the absolute path to a host configuration directory."""
    return host_dir() / hostname


def relative_to_repo(path: str) -> Path:
    """Convert a relative path from repo root to absolute path."""
    return repo_root() / path
