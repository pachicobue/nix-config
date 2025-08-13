{...}: {
  programs.virt-manager.enable = true;
  virtualisation = {
    docker = {
      enable = true;
      rootless.enable = true;
    };
    libvirtd = {
      enable = true;
      onBoot = "ignore";
    };
  };
}
