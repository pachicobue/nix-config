{
  delib,
  pkgs,
  lib,
  inputs,
  ...
}: let
  bashRtkHook = pkgs.replaceVars ./hooks/bash-rtk.py {
    rtk = lib.getExe pkgs.rtk;
  };
in
  delib.module {
    name = "programs.claude-code";
    options = delib.singleEnableOption false;

    home.ifEnabled = {
      home.packages = with pkgs; [
        llm-agents.ccusage
        rtk
      ];
      programs.mcp.enable = true;
      programs.claude-code = {
        enable = true;
        package = pkgs.llm-agents.claude-code;
        enableMcpIntegration = true;
        settings = {
          autoUpdates = false;
          autoCompactEnabled = true;
          enableAllProjectMcpServers = true;
          outputStyle = "Explanatory";
          sandbox = {
            enabled = true;
            failIfUnavailable = true;
            autoAllowBashIfSandboxed = true;
            allowUnsandboxedCommands = false;
          };
          defaultMode = "acceptEdits";
          permissions = {
            deny = [
              "Bash(sudo *)"
            ];
            ask = [
              "Bash(rm *)"
              "Bash(mv *)"
            ];
          };
          statusLine = {
            type = "command";
            command = "echo $(cat) | ccusage statusline";
            padding = 0;
          };
          theme = "dark";
          hooks.PreToolUse = [
            {
              matcher = "Bash";
              hooks = [
                {
                  type = "command";
                  command = "${lib.getExe pkgs.python3} ${bashRtkHook}";
                }
              ];
            }
          ];
        };
        plugins = {
          skill-creator = "${inputs.claude-plugins-official}/plugins/skill-creator";
          hookify = "${inputs.claude-plugins-official}/plugins/hookify";
          code-simplifier = "${inputs.claude-plugins-official}/plugins/code-simplifier";
          claude-md-management = "${inputs.claude-plugins-official}/plugins/claude-md-management";
        };
        skills = {
          nix-ecosystem = ./skills/nix-ecosystem;
          jj-commit = ./skills/jj-commit;
        };
      };

      xdg.mimeApps.defaultApplications = {
        "x-scheme-handler/claude-cli" = ["claude-code-url-handler.desktop"];
      };
    };
  }
