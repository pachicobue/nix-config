{
  delib,
  pkgs,
  lib,
  ...
}:
delib.module {
  name = "programs.lean-ctx";
  options = delib.singleEnableOption false;

  home.ifEnabled = {
    home.packages = [pkgs.llm-agents.lean-ctx];
    programs.mcp.enable = true;
    programs.mcp.servers.lean-ctx = {
      command = lib.getExe pkgs.llm-agents.lean-ctx;
      args = ["mcp"];
    };
  };
}
