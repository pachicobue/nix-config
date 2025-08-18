{
  hostname,
  username,
}: {
  inputs,
  config,
  pkgs,
  ...
}: {
  imports = [
    ../../../module/home/common.nix
    ../../../module/home/common-wayland.nix
    ../../../module/home/hyprland.nix

    ../../../module/home/cava.nix
    ../../../module/home/alacritty.nix
    ../../../module/home/firefox.nix
    ../../../module/home/obsidian.nix
    ../../../module/home/zed.nix
    ../../../module/home/discord.nix
    ../../../module/home/proton-pass.nix
    ../../../module/home/udiskie.nix
    ../../../module/home/ai.nix

    ## Installer not placed in repository. Place&Install manually!
    # ../../../module/home/mathematica.nix
  ];
  home.sessionVariables = {
    EDITOR = "hx";
  };

  # SSH Host
  age.secrets.vm_ssh_key = {
    symlink = true;
    path = "${config.home.homeDirectory}/.ssh/vm_key";
    file = "${inputs.my-nix-secret}/vm_ssh_key.age";
    mode = "0600";
  };
  home.file.".ssh/vm_key.pub" = {
    text = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMB1TSKY3WUvIuRePsQvCHMdlQkvlaPb5tENyT2uDGd5 vm-access-key";
  };
  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host vm-*
        Hostname localhost
        CheckHostIP no
        StrictHostKeyChecking no
        UserKnownHostsFile /dev/null
        IdentityFile ~/.ssh/vm_key
      Host vm-minimal
      Host vm-sandbox
    '';
  };
}
