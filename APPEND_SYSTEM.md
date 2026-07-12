# Global Rules

## Deployment
- Software deploys via NixOS oci-containers on another system. Local system only for testing. (Docker/Podman)

## Git
- Don't commit or push without explicit approval
- Don't auto-update files after testing queries/commands

## Tools
- Use nix shell for CLI tools (psql, ffmpeg, etc.)
- Prefer Python APIs over subprocess/CLI when available

## Code Style
- No setup scripts - put instructions in README
- Be concise in responses

## Testing
- Test queries/commands first, only update files when asked
