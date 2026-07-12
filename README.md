# Pi configuration

Personal portable configuration for [Pi](https://pi.dev).

It contains:

- global settings and package declarations;
- global appended system instructions;
- a custom context-usage footer extension.

Authentication, sessions, history, trust decisions, and installed package caches are intentionally excluded.

## Install on another host

Install Pi:

```bash
npm install -g --ignore-scripts @earendil-works/pi-coding-agent
```

Clone this repository and install the configuration:

```bash
git clone git@github.com:pandalanax/pi-config.git ~/pi-config
mkdir -p ~/.pi/agent
cp ~/pi-config/settings.json ~/.pi/agent/settings.json
cp ~/pi-config/APPEND_SYSTEM.md ~/.pi/agent/APPEND_SYSTEM.md
pi install git:git@github.com:pandalanax/pi-config.git
```

The final command registers this repository as a Pi package and loads its extension. Pi installs the other packages declared in `settings.json` when it starts.

Authenticate separately on each host:

```bash
pi
/login
```

Do not copy `auth.json` between hosts.

## Update a host

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
