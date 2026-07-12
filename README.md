# Pi configuration

Personal portable configuration for [Pi](https://pi.dev).

It contains:

- global settings and package declarations;
- global appended system instructions;
- a custom context-usage footer extension.

Authentication, sessions, history, trust decisions, and installed package caches are intentionally excluded.

## Extension security checks

The `Extension security audit` GitHub Actions workflow runs on changes to `settings.json`, on pull requests, manually, and every Monday. It:

- rejects npm package declarations that are not pinned to exact versions;
- installs dependencies in an isolated runner with lifecycle scripts disabled;
- verifies npm registry signatures with `npm audit signatures`;
- fails for known high or critical vulnerabilities reported by `npm audit`.

This reduces risk but cannot prove that a package is safe. A newly malicious release may not yet have a published advisory, so review extension source and version changes before updating pins.

## NixOS with Home Manager

This is the recommended installation method on NixOS. Add the public repository to the consuming flake:

```nix
{
  inputs.pi-config.url = "github:pandalanax/pi-config";
}
```

Import the provided module in the user's Home Manager configuration:

```nix
{ inputs, ... }:
{
  home-manager.users.pandalanax = {
    imports = [ inputs.pi-config.homeModules.default ];

    # Existing Home Manager configuration...
  };
}
```

The module installs Pi and configures the global settings, appended rules, and context-footer extension. Nix fetches this repository, so no manual clone, global npm install, or separately installed Node.js is required.

The configured third-party Pi packages are pinned in `settings.json`. Pi downloads those packages from npm into its user data directory when needed; they are not part of the Nix store and require network access on their first installation.

Update the pinned flake input from the consuming repository:

```bash
nix flake update pi-config
```

Then rebuild or deploy that system normally.

### Run the Nix package directly

```bash
nix run github:pandalanax/pi-config
```

This runs the packaged Pi binary without permanently installing it. The complete personal configuration is applied by the Home Manager or NixOS module, not by the standalone package output.

A NixOS module is also exported as `nixosModules.default` for system-wide installations:

```nix
{
  imports = [ inputs.pi-config.nixosModules.default ];
}
```

## Non-Nix installation

Install Pi:

```bash
npm install -g --ignore-scripts @earendil-works/pi-coding-agent
```

Clone this repository and install the configuration:

```bash
git clone https://github.com/pandalanax/pi-config.git ~/pi-config
mkdir -p ~/.pi/agent
cp ~/pi-config/settings.json ~/.pi/agent/settings.json
cp ~/pi-config/APPEND_SYSTEM.md ~/.pi/agent/APPEND_SYSTEM.md
pi install https://github.com/pandalanax/pi-config
```

The final command registers this repository as a Pi package and loads its extension. Pi installs the other pinned packages declared in `settings.json` when it starts.

Authenticate separately on each host:

```text
/login
```

Do not copy `auth.json` between hosts.

## Update a non-Nix host

```bash
cd ~/pi-config
git pull
cp settings.json ~/.pi/agent/settings.json
cp APPEND_SYSTEM.md ~/.pi/agent/APPEND_SYSTEM.md
pi update --extensions
```

Copying `settings.json` replaces host-local Pi settings. Review differences first if the host has local overrides.

## Update this repository from the primary host

Copy intentional changes from `~/.pi/agent` into this checkout, review them, and commit them explicitly. Never copy authentication, sessions, history, package caches, or trust data.
