# dotfiles

Public, user-scoped configuration files.

System entry-point files are intentionally tiny and source the corresponding
configuration from this repository. Machine-local settings and secrets must not
be committed.

## Managed configuration

- Bash: `.bashrc`
- tmux: `.tmux.conf` and `.config/tmux/`
- Ghostty: `.config/ghostty/config.ghostty`
- Helix: `.config/helix/config.toml`
- GNOME input settings: `.config/gnome/apply-input-settings.sh`
- Herdr: `.config/herdr/config.toml`
- Pi global instructions, settings, extensions, and skills: `.pi/agent/`

## Pi packages

`.pi/agent/settings.json` declares Pi packages by registry name. Pi installs the
package code in its runtime directory. The package code does not belong in this
repository.

`.pi/agent/pi-codex-conversion.json` stores the portable settings for
`@howaboua/pi-codex-conversion`.

Pi cannot include a second global settings file. Copy these canonical files to
the runtime directory after a fresh checkout:

```bash
install -m 600 .pi/agent/settings.json ~/.pi/agent/settings.json
install -m 600 .pi/agent/pi-codex-conversion.json ~/.pi/agent/pi-codex-conversion.json
```

Do not commit Pi credentials, sessions, package files, or machine-specific
audio device IDs.
