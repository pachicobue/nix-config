# denix / delib Reference

This config uses **denix** (`github:yunfachi/denix`) via `delib = denix.lib`.
It wraps the NixOS module system with a cleaner, more concise API.

## Module Definition

```nix
{ delib, pkgs, lib, inputs, ... }:
delib.module {
  name = "programs.foo";  # dot-separated path becomes the option path

  # Simple: only adds `programs.foo.enable`
  options = delib.singleEnableOption false;

  # Or: multiple options under `programs.foo.*`
  options = with delib; moduleOptions {
    enable    = boolOption false;
    package   = packageOption pkgs.foo;
    settings  = attrsOption {};
    extraArgs = listOption [];
  };

  # NixOS system config (only applies on NixOS)
  nixos.ifEnabled = { cfg, ... }: {
    environment.systemPackages = [ cfg.package ];
  };

  # home-manager config (always, regardless of enable)
  home.always = { ... }: { };

  # home-manager config (only when enabled)
  home.ifEnabled = { cfg, myconfig, ... }: {
    home.packages = [ cfg.package ];
  };

  # myconfig (shared values accessible in both nixos and home callbacks)
  myconfig.ifEnabled = { cfg, ... }: {
    # values set here are accessible as `myconfig.*` in other callbacks
  };
}
```

## Callback Arguments

```nix
home.ifEnabled = { cfg, config, pkgs, lib, myconfig, inputs, ... }: {
  # cfg        = shorthand for config.programs.foo (the module's own options)
  # config     = full NixOS/HM config tree
  # myconfig   = shared configuration values set via myconfig.* blocks
  # pkgs, lib, inputs = standard flake arguments
};
```

## Option Helpers

```nix
delib.boolOption default          # bool with default
delib.strOption default           # string with default
delib.intOption default           # integer with default
delib.listOption default          # list of anything
delib.attrsOption default         # attrs of anything
delib.packageOption default       # package option
delib.pathOption default          # path option
delib.enumOption [ "a" "b" ] def  # enum option

# Modifiers (chainable)
delib.allowNull option            # make nullable (nullOr)
delib.noDefault option            # remove default value
delib.readOnly option             # mark read-only
delib.description option "desc"   # add description string
delib.apply option func           # add apply transform
```

## singleEnableOption vs moduleOptions

```nix
# singleEnableOption: just `programs.foo.enable`
options = delib.singleEnableOption false;

# singleCascadeEnableOption: `programs.foo.enable` defaults to parent's enable
options = delib.singleCascadeEnableOption;

# moduleOptions: full set of options under `programs.foo.*`
options = with delib; moduleOptions {
  enable = boolOption false;
  # ...
};
```

## Common Patterns in This Repo

### replaceVars — string substitution in bundled files

```nix
# Substitute @placeholder@ in a file with a Nix store path
pkgs.replaceVars ./my-script.py {
  someTool = lib.getExe pkgs.some-tool;
}
# In the script: @someTool@ → /nix/store/.../bin/some-tool
```

### Conditional imports

```nix
home.ifEnabled = { myconfig, ... }: {
  imports = lib.optionals myconfig.someFlag [ ./extra-module.nix ];
};
```
