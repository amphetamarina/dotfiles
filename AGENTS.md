# Agent Instructions

This is a public repo. It is the source of truth for user config.
Local path: `~/Workspace/dotfiles`.

## Rules

- Never commit secrets, tokens, credentials, history, caches, or generated data.
- Do not use symlinks.
- Do not edit `/etc/bashrc` or other system files.
- Edit config in this repo, not in loader files.
- Keep loader files minimal.
- Ignore mise unless the user asks about it.
- Do not add commit co-authors.

## Files

| App | Loader | Config in repo |
| --- | --- | --- |
| Bash | `~/.bashrc` | `.bashrc` |
| Ghostty | `~/.config/ghostty/config.ghostty` | `.config/ghostty/config.ghostty` |
| Red | `~/.config/red/config.toml` (runtime copy) | `.config/red/config.toml` |
| GNOME input | `~/.config/autostart/dotfiles-input-settings.desktop` | `.config/gnome/apply-input-settings.sh` |
| Herdr | `HERDR_CONFIG_PATH` in Bash | `.config/herdr/config.toml` |
| Nushell | `~/.config/nushell/config.nu` | `.config/nushell/config.nu` |
| Pi | `~/.pi/agent/` loaders | `.pi/agent/` |
| Prime Agent | `~/.prime/agent/` runtime copies | `.pi/agent/AGENTS.md` and `.prime/agent/settings.json` |

Pi loaders point to the canonical agent instructions, extensions, and skills
in this repo. Prime Agent uses the same global instructions as Pi and has its
own canonical settings file.

Loaders contain only these directives:

```text
~/.bashrc: source ~/Workspace/dotfiles/.bashrc
Ghostty: config-file = "/home/amphetamarina/Workspace/dotfiles/.config/ghostty/config.ghostty"
Red: copy ~/Workspace/dotfiles/.config/red/config.toml to ~/.config/red/config.toml
GNOME input: run ~/Workspace/dotfiles/.config/gnome/apply-input-settings.sh
Herdr: export HERDR_CONFIG_PATH="$HOME/Workspace/dotfiles/.config/herdr/config.toml"
Nushell: source ~/Workspace/dotfiles/.config/nushell/config.nu
Prime Agent instructions: copy .pi/agent/AGENTS.md to ~/.prime/agent/AGENTS.md
Prime Agent settings: copy .prime/agent/settings.json to ~/.prime/agent/settings.json
```

Red and Prime Agent cannot include these canonical files. Keep the canonical
files in this repo. Copy them to their standard runtime paths.

For a new app, store its config in this repo and use the app's native include
command in its standard config file. Do not use a symlink. Ask the user if the
app cannot include another file. Update `README.md`.

## Checks

```bash
bash -n ~/.bashrc ~/Workspace/dotfiles/.bashrc
ghostty +validate-config
red --check-config
nu --config ~/.config/nushell/config.nu -c 'print "Nushell config OK"'
python -m json.tool .prime/agent/settings.json >/dev/null
git diff --check
git status --short
```

Review staged files for secrets. Push to `origin/main` unless told otherwise.
Do not rewrite published history without permission.
