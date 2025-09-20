"""
Subprocess utilities with logging.
Provides wrapper functions for subprocess operations with consistent logging.
"""

import subprocess
from pathlib import Path
from typing import List, Optional, Union

from logger import log, error


def run_command(
    cmd: List[str],
    *,
    cwd: Optional[Union[str, Path]] = None,
    capture_output: bool = False,
    check: bool = True,
) -> subprocess.CompletedProcess:
    """
    Run a command with logging.

    Args:
        cmd: Command and arguments as list
        cwd: Working directory for the command
        capture_output: Whether to capture stdout/stderr
        check: Whether to raise exception on non-zero exit

    Returns:
        CompletedProcess instance

    Raises:
        subprocess.CalledProcessError: If check=True and command fails
    """
    log(f"$ {' '.join(cmd)}")
    try:
        result = subprocess.run(
            cmd,
            cwd=cwd,
            capture_output=capture_output,
            text=True if capture_output else None,
            check=check,
        )
        return result
    except subprocess.CalledProcessError as e:
        error(f"Command failed with exit code {e.returncode}: {' '.join(cmd)}")
        if capture_output and e.stderr:
            error(f"Error output: {e.stderr.strip()}")
        raise


def call_command(
    cmd: List[str],
    *,
    cwd: Optional[Union[str, Path]] = None,
) -> int:
    """
    Call a command and return exit code (like subprocess.call).

    Args:
        cmd: Command and arguments as list
        cwd: Working directory for the command

    Returns:
        Exit code of the command
    """
    log(f"$ {' '.join(cmd)}")
    exit_code = subprocess.call(cmd, cwd=cwd)
    if exit_code != 0:
        error(f"Command failed with exit code {exit_code}: {' '.join(cmd)}")
    return exit_code


def run_command_with_output(
    cmd: List[str],
    *,
    cwd: Optional[Union[str, Path]] = None,
) -> subprocess.CompletedProcess:
    """
    Run a command and capture output.

    Args:
        cmd: Command and arguments as list
        cwd: Working directory for the command

    Returns:
        CompletedProcess with captured output

    Raises:
        subprocess.CalledProcessError: If command fails
    """
    return run_command(
        cmd,
        cwd=cwd,
        capture_output=True,
        check=True,
    )


def try_run_command(
    cmd: List[str],
    *,
    cwd: Optional[Union[str, Path]] = None,
    log_command: bool = True,
    log_errors: bool = True,
) -> Optional[subprocess.CompletedProcess]:
    """
    Try to run a command, returning None if it fails.

    Args:
        cmd: Command and arguments as list
        cwd: Working directory for the command
        log_command: Whether to log the command being executed
        log_errors: Whether to log errors

    Returns:
        CompletedProcess if successful, None if failed
    """
    try:
        return run_command(
            cmd,
            cwd=cwd,
            capture_output=True,
            check=True,
            log_command=log_command,
            log_success=False,
        )
    except subprocess.CalledProcessError as e:
        if log_errors:
            error(f"Command failed: {' '.join(cmd)}")
            if e.stderr:
                error(f"Error output: {e.stderr.strip()}")
        return None


# Convenience functions for common operations
