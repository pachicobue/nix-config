{hostname}: {pkgs, ...}: {
  # 最小限の設定
  system.stateVersion = "25.11";
  networking.hostName = hostname;
  users.users.root = {
    isSystemUser = true;
    password = "root";
  };

  # SSH + 基本設定
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      PermitRootLogin = "yes";
    };
  };

  # ネットワーク設定
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [22];
  };

  # kexec用パッケージ
  environment.systemPackages = with pkgs; [
    wget
    curl
  ];
}
