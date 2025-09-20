#!/usr/bin/env python3
"""
NixOS Kexec Setup Script (Step 1) - compatibility wrapper
"""

import sys
import os
sys.path.insert(0, os.path.dirname(__file__))

from nixos_installer import NixOSInstaller, SSHManager
import argparse

def main():
    parser = argparse.ArgumentParser(
        description="NixOS Kexec Setup Script (Step 1)",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  nixos-install-kexec.py root@192.168.1.100
  nixos-install-kexec.py root@vm-minimal --port 2222 --identity ~/.ssh/vm_key
  nixos-install-kexec.py root@vm-minimal -p 2222 -i ~/.ssh/vm_key

Environment Variables:
  KEXEC_URL        Custom kexec installer URL (optional)
        """
    )
    
    parser.add_argument("target_host", help="SSH target (user@host or host)")
    parser.add_argument("--port", "-p", help="SSH port (default: 22)")
    parser.add_argument("--identity", "-i", help="SSH private key file")
    parser.add_argument("--kexec-url", help="Custom kexec installer URL")
    
    args = parser.parse_args()
    
    ssh_manager = SSHManager(args.target_host, args.port, args.identity)
    installer = NixOSInstaller()
    
    return installer.setup_kexec(ssh_manager, args.kexec_url)

if __name__ == "__main__":
    sys.exit(main())