{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "uutils-coreutils";

  nixos.always = {
    # uutils-coreutils-noprefixはmeta.priorityが未設定(デフォルト5)、
    # GNU coreutils-full側がpriority=10に下げられているため、
    # systemPackagesに加えるだけでls/cp等のバイナリが優先的に採用される
    environment.systemPackages = [pkgs.uutils-coreutils-noprefix];
  };
}
