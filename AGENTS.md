# Repository Instructions

## Nix validation

Validate Pi configuration changes with:

```bash
nix flake check --no-build
nix build .#pi-coding-agent
./result/bin/pi --list-models
```

The final command is a smoke test of the built, configured Pi package. Remove the generated `result` symlink after testing.
