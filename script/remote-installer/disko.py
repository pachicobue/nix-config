#!/usr/bin/env python3
"""
NixOS Installation Script (Step 2+: After kexec) - compatibility wrapper
"""

import sys
import os
sys.path.insert(0, os.path.dirname(__file__))

from nixos_installer import NixOSInstaller, SSHManager
import argparse

def main():
    parser = argparse.ArgumentParser(
        description="NixOS Installation Script (Step 2+: After kexec)",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
This script handles Step 2+ of NixOS installation (after kexec is complete).

Examples:
  nixos-install-impl.py root@192.168.1.100 ./host/sandbox/disko-config.nix
  nixos-install-impl.py root@vm-minimal ./host/sandbox/disko-config.nix --port 2222 --identity ~/.ssh/vm_key
  nixos-install-impl.py root@vm-minimal ./host/sandbox/disko-config.nix -p 2222 -i ~/.ssh/vm_key
        """
    )
    
    parser.add_argument("target_host", help="SSH target (user@host or host) - should be NixOS installer")
    parser.add_argument("disko_config", help="Path to disko configuration file")
    parser.add_argument("--port", "-p", help="SSH port (default: 22)")
    parser.add_argument("--identity", "-i", help="SSH private key file")
    
    args = parser.parse_args()
    
    ssh_manager = SSHManager(args.target_host, args.port, args.identity)
    installer = NixOSInstaller()
    
    return installer.install_nixos(ssh_manager, args.disko_config)

if __name__ == "__main__":
    sys.exit(main())