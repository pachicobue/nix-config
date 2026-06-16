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
        bubblewrap
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
          env = {
            BASH_DEFAULT_TIMEOUT_MS = "300000";
            BASH_MAX_TIMEOUT_MS = "1200000";
            MAX_MCP_OUTPUT_TOKENS = "50000";
            MCP_TOOL_TIMEOUT = "120000";
            CLAUDE_CODE_MAX_OUTPUT_TOKENS = "32000";
            CLAUDE_CODE_AUTO_CONNECT_IDE = "0";
            CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC = "1";
            CLAUDE_CODE_ENABLE_TELEMETRY = "0";
            CLAUDE_CODE_IDE_SKIP_AUTO_INSTALL = "1";
            CLAUDE_CODE_IDE_SKIP_VALID_CHECK = "1";
            DISABLE_AUTOUPDATER = "1";
            DISABLE_ERROR_REPORTING = "1";
            DISABLE_INTERLEAVED_THINKING = "1";
            DISABLE_MICROCOMPACT = "1";
            DISABLE_NON_ESSENTIAL_MODEL_CALLS = "1";
            DISABLE_TELEMETRY = "1";
            ENABLE_EXPERIMENTAL_MCP_CLI = "false";
            ENABLE_TOOL_SEARCH = "true";
            CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS = "1";
          };
          statusLine = {
            type = "command";
            command = "echo $(cat) | ccusage statusline";
            padding = 0;
          };
          theme = "dark";
          hooks = {
            PreToolUse = [
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
        };
        plugins = [
          "${inputs.claude-plugins-official}/plugins/skill-creator"
          "${inputs.claude-plugins-official}/plugins/hookify"
          "${inputs.claude-plugins-official}/plugins/code-simplifier"
          "${inputs.claude-plugins-official}/plugins/claude-md-management"
        ];
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
