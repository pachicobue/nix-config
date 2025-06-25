{ pkgs, ... }:
{
  users.users.sho = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "video"
      "input"
      "uinput"
      "libvirt"
      "network"
    ];
    shell = pkgs.zsh;
  };
}
