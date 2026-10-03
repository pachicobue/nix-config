{
  delib,
  pkgs,
  lib,
  ...
}: let
  bashRtkHook = pkgs.replaceVars ./hooks/bash-rtk.py {
    rtk = lib.getExe pkgs.rtk;
  };
in
  delib.module {
    name = "programs.codex";
    options = delib.singleEnableOption false;

    home.ifEnabled = {
      home.packages = with pkgs; [
        bubblewrap
        rtk
      ];
      programs.mcp.enable = true;
      programs.codex = {
        enable = true;
        package = pkgs.llm-agents.codex;
        enableMcpIntegration = true;
        # Codex persists trust and UI settings in config.toml, so merge declared
        # settings into a writable file instead of linking it from the Nix store.
        mutableSettings = true;
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
