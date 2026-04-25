{
  delib,
  host,
  hosts,
  lib,
  ...
}: let
  # 全ホストのSSH公開鍵を集める
  keys = lib.flatten (lib.mapAttrsToList (_: h: h.network.sshPublicKey) hosts);
in
  delib.module {
    name = "services.sshd";
    options = delib.singleEnableOption host.sshServerFeatured;
    nixos.ifEnabled = {
      users.users.root.openssh.authorizedKeys.keys = keys;
      services.openssh = {
        enable = true;
        settings = {
          X11Forwarding = host.x11Featured;
          PermitRootLogin = "prohibit-password";
          PasswordAuthentication = false;
          UsePAM = false;
        };
      };
      environment.enableAllTerminfo = true;
    };
  }
