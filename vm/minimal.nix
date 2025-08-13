{hostname}: {pkgs, ...}: {
  # 最小限の設定
  networking.hostName = hostname;
  boot.loader.grub.device = "/dev/vda";
  fileSystems."/" = {
    device = "/dev/vda1";
    fsType = "ext4";
  };

  # VM設定
  virtualisation.vmVariant = {
    virtualisation.memorySize = 8192;
    virtualisation.cores = 2;
    virtualisation.diskSize = 131072; # 128GB
    virtualisation.graphics = false;
    virtualisation.forwardPorts = [
      {
        from = "host";
        host.port = 2222;
        guest.port = 22;
      }
    ];
  };
  users.users.test = {
    isNormalUser = true;
    initialPassword = "test";
    group = "test";
  };
  users.groups.test = {};

  # # SSH + 基本設定
  # services.openssh.enable = true;
  # users.users.root.openssh.authorizedKeys.keys = ["your-ssh-key"];

  # kexec用パッケージ
  environment.systemPackages = with pkgs; [
    wget
    curl
  ];
}
