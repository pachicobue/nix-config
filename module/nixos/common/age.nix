{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    sops
    rage
    ssh-to-age
  ];
}
