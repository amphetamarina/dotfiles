# Agent Instructions

This is a public repo. It is the source of truth for user config.
Local path: `~/workspace/dotfiles`.

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
| tmux | `~/.tmux.conf` | `.tmux.conf` |
| Ghostty | `~/.config/ghostty/config.ghostty` | `.config/ghostty/config.ghostty` |
| Helix | `~/.local/bin/hx` | `.config/helix/config.toml` |
| GNOME input | `~/.config/autostart/dotfiles-input-settings.desktop` | `.config/gnome/apply-input-settings.sh` |
| Pi | `~/.pi/agent/AGENTS.md` | `.pi/agent/AGENTS.md` |

Tmux helper scripts are in `.config/tmux/`. The Pi loader tells agents to read
the canonical file in this repo.

Loaders contain only these directives:

```text
~/.bashrc: source ~/workspace/dotfiles/.bashrc
~/.tmux.conf: source-file ~/workspace/dotfiles/.tmux.conf
Ghostty: config-file = "/home/amphetamarina/workspace/dotfiles/.config/ghostty/config.ghostty"
Helix: /usr/bin/hx --config ~/workspace/dotfiles/.config/helix/config.toml
GNOME input: run ~/workspace/dotfiles/.config/gnome/apply-input-settings.sh
```

For a new app, store its config in this repo and use the app's native include
command in its standard config file. Do not use a symlink. Ask the user if the
app cannot include another file. Update `README.md`.

## Checks

```bash
bash -n ~/.bashrc ~/workspace/dotfiles/.bashrc
tmux source-file ~/.tmux.conf
ghostty +validate-config
git diff --check
git status --short
```

Review staged files for secrets. Push to `origin/main` unless told otherwise.
Do not rewrite published history without permission.
