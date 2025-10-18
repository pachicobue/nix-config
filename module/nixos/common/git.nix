{pkgs, ...}: {
  environment.systemPackages = [
    pkgs.git
    pkgs.gh
  ];
}
