---
name: nix-ecosystem
description: >
  Expert knowledge of the Nix ecosystem — Nix language, NixOS module system,
  Flakes, derivations/packaging, home-manager, and this repo's denix/delib
  framework (delib.module, myconfig.*, hosts/, rices/, modules/programs,
  modules/services). Use this skill for ANY task that touches a .nix file,
  even ones that look small or mechanical — changing a single option value,
  swapping a package reference, looking up a package's correct pname on
  nixpkgs, adding a host, or debugging `nix flake check`/`switch` failures
  all count. Trigger even if the user never says "Nix" explicitly: a .nix
  path, flake.nix/flake.lock, a nixpkgs package name, or repo-specific terms
  like myconfig, stylix, agenix, or hosts/rices/modules paths are enough on
  their own.
---

# Nix Ecosystem Knowledge

## Nix Language

Nix is a lazy, purely functional language. Every value is an expression; there
are no statements or side effects.

### Core Syntax

```nix
# Attribute set
{ foo = 1; bar = "hello"; }

# Let binding
let x = 1; y = 2; in x + y

# Function (single argument, use attrset for multiple)
name: "Hello, ${name}!"
{ name, age ? 0 }: "Name: ${name}, Age: ${toString age}"

# With (import names from an attrset into scope)
with lib; optional condition value

# Inherit (shorthand for foo = foo)
{ inherit pkgs lib; inherit (pkgs) stdenv; }

# Recursive attrset (values can refer to each other)
rec { a = 1; b = a + 1; }

# List
[ 1 "two" true ]

# String interpolation
"Hello ${name}!"

# Multiline string (strips common leading whitespace)
''
  line one
  line two
''

# Import another .nix file
import ./module.nix { inherit pkgs; }
```

### Useful Builtins

```nix
builtins.toString x        # convert to string
builtins.toJSON x          # serialize to JSON string
builtins.fromJSON str      # parse JSON string
builtins.readFile ./file   # read file as string
builtins.attrNames attrs   # list of attribute names
builtins.mapAttrs f attrs  # map over attribute set
builtins.filter pred list  # filter a list
builtins.concatLists lists # flatten one level
builtins.elem x list       # check membership
```

### nixpkgs `lib` Functions (commonly used)

```nix
lib.mkIf condition value       # conditional value in module config
lib.mkForce value              # override with highest priority
lib.mkDefault value            # set with lower-than-default priority
lib.mkMerge [a b c]           # merge multiple config fragments
lib.optional cond x            # [x] if cond else []
lib.optionals cond list        # list if cond else []
lib.optionalAttrs cond attrs   # attrs if cond else {}
lib.getExe pkg                 # get the main executable path from a package
lib.splitString sep str        # split string into list
lib.concatStringsSep sep list  # join list into string
lib.nameValuePair name value   # create { name = ...; value = ...; }
lib.listToAttrs [ { name="a"; value=1; } ]  # list → attrset
lib.attrValues attrs           # get values as list
lib.mapAttrsToList f attrs     # map over attrs, return list
lib.filterAttrs pred attrs     # filter attribute set
lib.recursiveUpdate a b        # deep merge (b wins on conflict)
lib.hasAttr "foo" attrs        # check attribute exists
lib.getAttr "foo" attrs        # get attribute (throws if missing)
lib.attrByPath ["a" "b"] default attrs  # nested attribute access
lib.setAttrByPath ["a" "b"] value attrs # nested attribute set
lib.flatten list               # fully flatten nested lists
lib.unique list                # remove duplicates
lib.toList x                   # wrap in list if not already a list
lib.types.*                    # NixOS option types (see Module System section)
```

---

## NixOS Module System

Modules are functions that return an attribute set with specific keys.

### Standard Module Structure

```nix
{ config, lib, pkgs, ... }:
{
  imports = [ ./other-module.nix ];

  options = {
    myModule.enable = lib.mkEnableOption "my module";
    myModule.package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.hello;
      description = "Package to use.";
    };
  };

  config = lib.mkIf config.myModule.enable {
    environment.systemPackages = [ config.myModule.package ];
  };
}
```

### Common Option Types

```nix
lib.types.bool
lib.types.str
lib.types.int
lib.types.float
lib.types.path
lib.types.package
lib.types.listOf lib.types.str
lib.types.attrsOf lib.types.str
lib.types.nullOr lib.types.str
lib.types.enum [ "a" "b" "c" ]
lib.types.oneOf [ lib.types.str lib.types.int ]
lib.types.submodule { options = { ... }; }
lib.types.anything
```

### Priority System

```nix
lib.mkDefault value   # priority 1000 (easily overridden)
# (no wrapper)        # priority 100 (normal)
lib.mkForce value     # priority 50 (hard to override)
lib.mkOverride 500 v  # explicit priority
```

---

## Flakes

### flake.nix Structure

```nix
{
  description = "My flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";  # pin to parent's nixpkgs
    };
    some-flake.flake = false;  # non-flake source (no outputs)
  };

  outputs = { self, nixpkgs, home-manager, ... } @ inputs:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    # NixOS system
    nixosConfigurations.hostname = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [ ./configuration.nix ];
      specialArgs = { inherit inputs; };
    };

    # Packages
    packages.${system}.default = pkgs.callPackage ./package.nix {};

    # Dev shell
    devShells.${system}.default = pkgs.mkShell {
      packages = [ pkgs.git ];
    };
  };
}
```

### Flake References

```nix
# GitHub (tarball, no git history)
"github:owner/repo"
"github:owner/repo/branch-or-tag"
"github:owner/repo?rev=abc123"

# Local path
"path:/absolute/path"
"./relative/path"  # only in inputs

# Other forges
"gitlab:owner/repo"
"sourcehut:~user/repo"
```

### flake.lock

Lock file is auto-generated. Update with:
```bash
nix flake update               # update all inputs
nix flake update nixpkgs       # update specific input
nix flake lock --update-input some-input
```

---

## Derivations and Packaging

### stdenv.mkDerivation

```nix
{ stdenv, fetchurl, lib }:
stdenv.mkDerivation {
  pname = "hello";
  version = "2.12";

  src = fetchurl {
    url = "mirror://gnu/hello/hello-2.12.tar.gz";
    hash = "sha256-...";
  };

  # Build phases (each can be overridden)
  buildInputs = [ ];       # compile-time deps
  nativeBuildInputs = [ ]; # host-run build tools (compilers, etc.)
  propagatedBuildInputs = []; # runtime deps exposed to dependents

  configurePhase = "...";  # or use dontConfigure = true;
  buildPhase = "...";
  installPhase = "...";
  checkPhase = "...";      # or doCheck = true/false

  meta = {
    description = "A program that produces a familiar, friendly greeting";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.eelco ];
    mainProgram = "hello";
  };
}
```

### Fetchers

```nix
fetchurl { url = "..."; hash = "sha256-..."; }
fetchzip { url = "..."; hash = "sha256-..."; stripRoot = false; }
fetchFromGitHub {
  owner = "owner"; repo = "repo"; rev = "v1.0.0"; hash = "sha256-...";
}
fetchFromGitLab { owner = "..."; repo = "..."; rev = "..."; hash = "..."; }
fetchgit { url = "..."; rev = "..."; hash = "sha256-..."; }
```

### Override Patterns

```nix
# Override attributes
pkg.overrideAttrs (old: {
  version = "2.0";
  patches = old.patches ++ [ ./my.patch ];
})

# Override dependencies
pkg.override { openssl = pkgs.openssl_3; }

# callPackage pattern
pkgs.callPackage ./my-package.nix { extraDep = pkgs.foo; }
```

### Overlays

```nix
# In flake outputs
overlays.default = final: prev: {
  myPkg = final.callPackage ./pkgs/my-pkg {};
  # Override existing package
  hello = prev.hello.overrideAttrs { version = "2.12.1"; };
};

# Apply overlay
pkgs = import nixpkgs {
  inherit system;
  overlays = [ self.overlays.default ];
};
```

---

## home-manager

home-manager manages user-level packages and dotfiles.

### Basic Structure

```nix
{ config, pkgs, lib, ... }:
{
  home.username = "user";
  home.homeDirectory = "/home/user";
  home.stateVersion = "24.11";  # DO NOT change after initial setup

  home.packages = with pkgs; [ git ripgrep ];

  # Dotfiles
  home.file.".config/foo/config.toml".text = ''
    setting = "value"
  '';
  home.file.".config/bar".source = ./bar-config;

  # Managed programs
  programs.git = {
    enable = true;
    userName = "Name";
    userEmail = "email@example.com";
  };

  # XDG directories
  xdg.userDirs = {
    enable = true;
    pictures = "${config.home.homeDirectory}/Pictures";
  };
}
```

### Key home-manager Patterns

```nix
# Conditional configuration
programs.foo = lib.mkIf config.services.bar.enable { enable = true; };

# Program with init extra
programs.zsh.initExtra = ''
  export MY_VAR="value"
'';

# Systemd user service
systemd.user.services.my-service = {
  Unit.Description = "My service";
  Service = { ExecStart = "${pkgs.my-pkg}/bin/my-cmd"; };
  Install.WantedBy = [ "default.target" ];
};
```

---

## denix / delib (this project's module framework)

This config uses **denix** (`github:yunfachi/denix`) as a wrapper around the
NixOS module system. When the user is working with `delib.module`,
`delib.moduleOptions`, `singleEnableOption`, or any `delib.*` API, read
`references/delib.md` for the full reference.

---

## Debugging Tips

```bash
# Evaluate a Nix expression
nix eval '.#nixosConfigurations.hostname.config.environment.systemPackages' --apply 'builtins.length'

# Check what a derivation builds to
nix build '.#packages.x86_64-linux.myPkg' --dry-run

# Trace evaluation (add to Nix code)
builtins.trace "value is: ${builtins.toJSON myValue}" myValue

# Check flake outputs
nix flake show

# Build and check NixOS config
nix flake check
nixos-rebuild dry-build --flake .#hostname
```
