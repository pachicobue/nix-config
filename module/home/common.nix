{
  inputs,
  config,
  ...
}: {
  # nix-secret 参照
  # age.identityPaths = [
  #   "${config.home.homeDirectory}/.ssh/agenix"
  # ];

  imports = [
    # inputs.agenix.homeManagerModules.default

    ./common/xdg.nix
    ./common/atuin.nix
    ./common/carapace.nix
    ./common/starship.nix
    ./common/git.nix
    ./common/lsd.nix
    ./common/ssh.nix
    # ./common/pueue.nix
    ./common/zsh.nix
    ./common/zoxide.nix
  ];
}
