{
  delib,
  host,
  ...
}:
delib.module {
  name = "services.sshd";
  options = delib.singleEnableOption false;

  nixos.ifEnabled = {
    users.users.sho.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMJGjzlH+kjBX98qiZOQ1raIQ2H6CJefEq3c8LO4uSuP sho@coconut"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIurSBgviLvpzHnZOMuu7UEbw9sktSuVahUySjW0dquy sho@plum"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ9zd4/wJ4gleti/ciOfbI0wMi/lG7Rkgc9Q2jyjA7Cg iPhone XR"
    ];
    users.users.root.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMJGjzlH+kjBX98qiZOQ1raIQ2H6CJefEq3c8LO4uSuP sho@coconut"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIurSBgviLvpzHnZOMuu7UEbw9sktSuVahUySjW0dquy sho@plum"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ9zd4/wJ4gleti/ciOfbI0wMi/lG7Rkgc9Q2jyjA7Cg iPhone XR"
    ];
    services.openssh = {
      enable = true;
      settings = {
        X11Forwarding = host.x11Featured;
        PermitRootLogin = "prohibit-password";
        PasswordAuthentication = false;
      };
    };
    environment.enableAllTerminfo = true;
  };
  home.ifEnabled = {
    services.ssh-agent.enable = true;
  };
}
