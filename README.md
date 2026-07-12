# Pi config

My portable [Pi](https://pi.dev) configuration:


## NixOS

Add the input to your flake:

```nix
inputs.pi-config.url = "github:pandalanax/pi-config";
```

Import its NixOS module:

```nix
{
  imports = [ inputs.pi-config.nixosModules.default ];
}
```

This installs the configured `pi` command system-wide. No clone, global npm installation, or separate Node.js installation is required. Authentication, sessions, and downloaded packages remain separate for each user under `~/.pi/agent/`.

## Non-Nix installation

```bash
npm install -g --ignore-scripts @earendil-works/pi-coding-agent
git clone https://github.com/pandalanax/pi-config.git ~/pi-config

mkdir -p ~/.pi/agent
cp ~/pi-config/settings.json ~/pi-config/APPEND_SYSTEM.md ~/.pi/agent/

pi install https://github.com/pandalanax/pi-config
```
