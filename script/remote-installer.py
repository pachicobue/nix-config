#!/usr/bin/env python3
"""
NixOS Installation Scripts
Converts nixos-install-impl.sh, nixos-install-kexec.sh, and remote-installer.sh to Python.
"""

import sys
import os
import subprocess
import argparse
import time
import shlex
from pathlib import Path
from typing import List, Optional, Tuple
from util.logger import log, error, warn, success, Colors
from util.subprocess_utils import call_command, run_command_with_output


class SSHManager:
    """Handle SSH connection management with various options."""

    def __init__(
        self,
        target_host: str,
        port: Optional[str] = None,
        identity: Optional[str] = None,
    ):
        self.target_host = target_host
        self.port = port
        self.identity = identity
        self.ssh_opts = self._build_ssh_opts()
        self.scp_opts = self._build_scp_opts()

    def _build_ssh_opts(self) -> List[str]:
        """Build SSH options array."""
        opts = []
        if self.port:
            opts.extend(["-p", self.port])
        if self.identity:
            opts.extend(["-i", self.identity])
        return opts

    def _build_scp_opts(self) -> List[str]:
        """Build SCP options array (uses -P for port)."""
        opts = []
        if self.port:
            opts.extend(["-P", self.port])  # SCP uses -P for port
        if self.identity:
            opts.extend(["-i", self.identity])
        return opts

    def run_ssh_command(
        self, command: str, capture_output: bool = False
    ) -> subprocess.CompletedProcess:
        """Run SSH command on target host."""
        cmd = ["ssh"] + self.ssh_opts + [self.target_host, command]
        log(
            f"Executing: ssh {' '.join(self.ssh_opts)} \"{self.target_host}\" '{command}'"
        )

        if capture_output:
            return subprocess.run(cmd, capture_output=True, text=True)
        else:
            return subprocess.run(cmd)

    def run_ssh_script(self, script_content: str) -> int:
        """Run a shell script over SSH."""
        cmd = ["ssh"] + self.ssh_opts + [self.target_host, "bash", "-s"]
        log(
            f"Executing: ssh {' '.join(self.ssh_opts)} \"{self.target_host}\" 'bash -s'"
        )

        try:
            process = subprocess.Popen(cmd, stdin=subprocess.PIPE, text=True)
            process.communicate(input=script_content)
            return process.returncode
        except Exception as e:
            error(f"Failed to run SSH script: {e}")
            return 1

    def copy_file(self, local_path: str, remote_path: str) -> int:
        """Copy file to target host using SCP."""
        cmd = (
            ["scp"] + self.scp_opts + [local_path, f"{self.target_host}:{remote_path}"]
        )
        return call_command(cmd, log_success=True, success_message=f"File copied to {self.target_host}:{remote_path}")


class NixOSInstaller:
    """Main NixOS installer class."""

    def __init__(self):
        self.default_kexec_url = "https://github.com/nix-community/nixos-images/releases/download/nixos-unstable/nixos-kexec-installer-x86_64-linux.tar.gz"

    def setup_kexec(
        self, ssh_manager: SSHManager, kexec_url: Optional[str] = None
    ) -> int:
        """Setup kexec installer on target host (Step 1)."""
        kexec_url = kexec_url or os.environ.get("KEXEC_URL", self.default_kexec_url)

        log("Setting up kexec installer on target host")
        log(f"Target: {ssh_manager.target_host}")
        log(f"SSH port: {ssh_manager.port or '22'}")
        log(f"SSH identity: {ssh_manager.identity or 'default'}")
        log(f"Kexec URL: {kexec_url}")

        script_content = f'''set -euo pipefail

log() {{
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}}

log "Downloading kexec installer..."
cd /root
curl -L "{kexec_url}" | tar -xzf-

log "Executing kexec installer..."
/root/kexec/run &

log "Kexec installer started. Connection will be lost momentarily..."
exit 0
'''

        result = ssh_manager.run_ssh_script(script_content)
        if result != 0:
            error("Failed to setup kexec installer")
            return result

        success("Kexec installer setup complete")
        log("Waiting for NixOS installer to boot...")

        # Wait for kexec to complete
        time.sleep(30)

        # Try to verify installer is ready
        for i in range(1, 11):
            log(
                f"Verification attempt {i}/10: Testing connection to NixOS installer..."
            )
            try:
                result = ssh_manager.run_ssh_command(
                    'echo "NixOS installer ready"', capture_output=True
                )
                if result.returncode == 0:
                    success("NixOS installer is ready and accessible")
                    return 0
            except:
                pass

            log("Installer not ready yet, waiting...")
            time.sleep(10)

        warn("Could not verify installer readiness, but continuing anyway")
        log("NixOS installer should be ready for the next phase")
        return 0

    def install_nixos(self, ssh_manager: SSHManager, disko_config: str) -> int:
        """Run NixOS installation (Step 2+)."""
        if not os.path.exists(disko_config):
            error(f"Disko config file not found: {disko_config}")
            return 1

        log("Running NixOS installation (Step 2+)")
        log(f"Target: {ssh_manager.target_host}")
        log(f"Disko config: {disko_config}")
        log(f"SSH port: {ssh_manager.port or '2222'}")
        log(f"SSH identity: {ssh_manager.identity or 'default'}")

        # Step 2: Connect to NixOS installer
        log("Step 2: Connecting to NixOS installer...")

        for i in range(1, 31):
            log(f"Retry {i}/30: Attempting to connect to NixOS installer...")

            try:
                result = ssh_manager.run_ssh_command(
                    'echo "Connected to NixOS installer"', capture_output=True
                )
                if result.returncode == 0:
                    success("Successfully connected to NixOS installer")
                    break
            except:
                pass

            if i == 30:
                error("Failed to connect to NixOS installer after 30 attempts")
                return 1

            log("Connection failed, waiting 5 seconds before retry...")
            time.sleep(5)

        # Step 3: Copy disko config and run installation
        log("Step 3: Running disko partitioning and NixOS installation")

        log("Copying disko configuration...")
        if ssh_manager.copy_file(disko_config, "/tmp/disko-config.nix") != 0:
            error("Failed to copy disko configuration")
            return 1

        # Run installation script
        install_script = """set -euo pipefail

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

error() {
    echo "[ERROR] $1" >&2
}

DISKO_CONFIG="/tmp/disko-config.nix"

if [ ! -f "$DISKO_CONFIG" ]; then
    error "Disko config not found at $DISKO_CONFIG"
    exit 1
fi

log "Preparing disko execution..."
log "Will use 'nix run' to execute disko directly from GitHub"

log "Running disko partitioning..."

# Use nix run approach which is more reliable in NixOS installer
log "Using nix run to execute disko with automatic disk wiping..."
nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount --yes-wipe-all-disks "$DISKO_CONFIG"

log "Generating NixOS configuration..."
nixos-generate-config --root /mnt

log "Installing NixOS..."
nixos-install --root /mnt --no-root-passwd

log "NixOS installation completed successfully!"
log "You can now reboot the system and it will boot into NixOS"
"""

        result = ssh_manager.run_ssh_script(install_script)
        if result != 0:
            error("NixOS installation failed")
            return result

        success("NixOS installation completed successfully!")

        # Print summary
        self._print_summary(ssh_manager, disko_config)
        return 0

    def full_install(
        self,
        ssh_manager: SSHManager,
        disko_config: str,
        kexec_url: Optional[str] = None,
    ) -> int:
        """Run complete NixOS installation (orchestrator)."""
        log("Starting NixOS clean installation orchestrator")
        log(f"Target: {ssh_manager.target_host}")
        log(f"Disko config: {disko_config}")

        # Phase 1: Setup kexec installer
        log("Phase 1: Setting up kexec installer...")
        if self.setup_kexec(ssh_manager, kexec_url) != 0:
            error("Phase 1 (kexec setup) failed")
            return 1

        success("Phase 1 completed successfully")
        log("Proceeding to Phase 2 after brief pause...")
        time.sleep(5)

        # Phase 2: Run installation
        log("Phase 2: Running NixOS installation...")
        if self.install_nixos(ssh_manager, disko_config) != 0:
            error("Phase 2 (NixOS installation) failed")
            return 1

        success("NixOS installation completed successfully!")
        return 0

    def _print_summary(self, ssh_manager: SSHManager, disko_config: str):
        """Print installation summary."""
        ssh_opts_str = " ".join(ssh_manager.ssh_opts)
        reboot_cmd = (
            f"ssh {ssh_opts_str} \"{ssh_manager.target_host}\" 'reboot'"
            if ssh_opts_str
            else f"ssh \"{ssh_manager.target_host}\" 'reboot'"
        )

        print(f"""
{Colors.GREEN}Installation Summary:{Colors.NC}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✅ Target Host: {ssh_manager.target_host}
✅ Disko Config: {disko_config}
✅ Partitioning completed with disko
✅ NixOS installed successfully

{Colors.YELLOW}Next Steps:{Colors.NC}
1. Reboot the target system: {reboot_cmd}
2. Wait for system to restart and boot into NixOS
3. Configure your NixOS system as needed

{Colors.BLUE}Note:{Colors.NC} The system has been installed without a root password.
You may need to configure authentication before the next boot.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
""")


def create_parser() -> argparse.ArgumentParser:
    """Create argument parser for the installer."""
    parser = argparse.ArgumentParser(description="NixOS Installation Utilities")
    subparsers = parser.add_subparsers(dest="command", help="Available commands")

    # Common arguments
    def add_common_args(subparser):
        subparser.add_argument("target_host", help="SSH target (user@host or host)")
        subparser.add_argument("--port", "-p", help="SSH port (default: 22)")
        subparser.add_argument("--identity", "-i", help="SSH private key file")

    # kexec command
    kexec_parser = subparsers.add_parser("kexec", help="Setup kexec installer (Step 1)")
    add_common_args(kexec_parser)
    kexec_parser.add_argument("--kexec-url", help="Custom kexec installer URL")

    # install command
    install_parser = subparsers.add_parser(
        "install", help="Run NixOS installation (Step 2+)"
    )
    add_common_args(install_parser)
    install_parser.add_argument("disko_config", help="Path to disko configuration file")

    # full command (orchestrator)
    full_parser = subparsers.add_parser(
        "full", help="Run complete installation (Step 1 + 2+)"
    )
    add_common_args(full_parser)
    full_parser.add_argument("disko_config", help="Path to disko configuration file")
    full_parser.add_argument("--kexec-url", help="Custom kexec installer URL")

    return parser


def main() -> int:
    parser = create_parser()
    args = parser.parse_args()

    if not args.command:
        parser.print_help()
        return 1

    # Create SSH manager
    ssh_manager = SSHManager(args.target_host, args.port, args.identity)
    installer = NixOSInstaller()

    if args.command == "kexec":
        return installer.setup_kexec(ssh_manager, getattr(args, "kexec_url", None))
    elif args.command == "install":
        return installer.install_nixos(ssh_manager, args.disko_config)
    elif args.command == "full":
        return installer.full_install(
            ssh_manager, args.disko_config, getattr(args, "kexec_url", None)
        )

    return 1


if __name__ == "__main__":
    sys.exit(main())
