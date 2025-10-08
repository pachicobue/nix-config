{
  config,
  lib,
  ...
}: {
  networking = {
    networkmanager.enable = true;

    nftables.enable = true;
    firewall = let
      tailscale = port: ''iifname "tailscale0" tcp dport ${builtins.toString port} accept comment "SSH via Tailscale interface"'';
      private = port: ''ip saddr { 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16 } tcp dport ${builtins.toString port} accept comment "SSH from private networks"'';
    in {
      enable = true;
      extraInputRules = ''
        # Tailscaleインターフェース経由のSSHを許可
        ${lib.strings.concatMapStringsSep "\n" tailscale config.services.openssh.ports}
        # プライベートネットワークからのSSHを許可
        ${lib.strings.concatMapStringsSep "\n" private config.services.openssh.ports}
      '';
    };
  };
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
  };
}
