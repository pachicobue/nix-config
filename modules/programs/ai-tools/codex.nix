{
  delib,
  pkgs,
  lib,
  config,
  moduleSystem,
  ...
}: let
  bashRtkHook = pkgs.replaceVars ./hooks/bash-rtk.py {
    rtk = lib.getExe pkgs.rtk;
  };
in
  delib.module {
    name = "programs.codex";
    options = delib.singleEnableOption false;

    # Temporary workaround: keep Nix defaults in /etc and the user config writable.
    # TODO: Switch to Home Manager's mutable settings support once available:
    # https://github.com/nix-community/home-manager/issues/9397
    # Then remove this /etc configuration and the home.file enable override below.
    nixos.ifEnabled = {myconfig, ...}: {
      # Reuse Home Manager's generated settings, including MCP integration.
      environment.etc."codex/config.toml".source =
        config.home-manager.users.${myconfig.constants.userName}.home.file.".codex/config.toml".source;
    };

    home.ifEnabled = {
      home.packages = with pkgs; [
        bubblewrap
        rtk
      ];
      # Codex persists trust and UI settings here; only the system defaults
      # belong in the Nix store. Keep the generated source for /etc above.
      home.file.".codex/config.toml".enable = lib.mkIf (moduleSystem == "nixos") false;
      programs.mcp.enable = true;
      programs.codex = {
        enable = true;
        package = pkgs.llm-agents.codex;
        enableMcpIntegration = true;
        settings = {
          check_for_update_on_startup = false;
          sandbox_mode = "workspace-write";
          approval_policy = "on-request";
        };
        # Keep default.rules free for Codex to save approved commands.
        rules.sudo = ''
          prefix_rule(pattern = ["sudo"], decision = "forbidden")
        '';
        hooks.PreToolUse = [
          {
            matcher = "Bash";
            hooks = [
              {
                type = "command";
                command = "${lib.getExe pkgs.python3} ${bashRtkHook} --codex";
              }
            ];
          }
        ];
        skills = {
          nix-ecosystem = ./skills/nix-ecosystem;
          jj-commit = ./skills/jj-commit;
        };
      };
    };
  }
