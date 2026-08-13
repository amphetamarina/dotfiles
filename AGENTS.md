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
| GNOME input | `~/.config/autostart/dotfiles-input-settings.desktop` | `.config/gnome/apply-input-settings.sh` |
| Herdr | `HERDR_CONFIG_PATH` in Nushell | `.config/herdr/config.toml` |
| Nushell | `~/.config/nushell/config.nu` | `.config/nushell/config.nu` |
| DeepSeek Harness | `~/.dsh/cordis.patch.yml` | `.config/deepseek-harness/` |
| Workspace tools | `~/Workspace/mise.toml` | `workspace-setup/mise.toml` |
| Pi | `~/.pi/agent/` loaders | `.pi/agent/` |
| Codex | `~/.codex/` runtime files | `.codex/config.toml` and `.pi/agent/AGENTS.md` |
| Prime Agent | `~/.prime/agent/` runtime files | `.pi/agent/AGENTS.md`, `.prime/agent/settings.json`, `.prime/agent/models.json`, `.prime/agent/themes/`, `.prime/agent/extensions/`, and `.prime/agent/skills/exa/` |

Pi loaders point to the canonical agent instructions, extensions, and skills
in this repo. Codex and Prime Agent use the same global instructions as Pi.
They have their own canonical settings files.

Loaders contain only these directives:

```text
GNOME input: run ~/Workspace/dotfiles/.config/gnome/apply-input-settings.sh
Herdr: $env.HERDR_CONFIG_PATH = "/home/amphetamarina/Workspace/dotfiles/.config/herdr/config.toml"
Nushell: source ~/Workspace/dotfiles/.config/nushell/config.nu
DeepSeek Harness: copy .config/deepseek-harness/cordis.patch.yml to ~/.dsh/cordis.patch.yml
Workspace tools: copy ~/Workspace/dotfiles/workspace-setup/mise.toml to ~/Workspace/mise.toml
Codex instructions: copy .pi/agent/AGENTS.md to ~/.codex/AGENTS.md
Codex settings: copy .codex/config.toml to ~/.codex/config.toml
Prime Agent instructions: copy .pi/agent/AGENTS.md to ~/.prime/agent/AGENTS.md
Prime Agent settings: copy .prime/agent/settings.json to ~/.prime/agent/settings.json
Prime Agent models: copy .prime/agent/models.json to ~/.prime/agent/models.json
Prime Agent themes: copy .prime/agent/themes/*.json to ~/.prime/agent/themes/
```

Prime Agent cannot include its canonical settings or custom model file. Keep the
canonical files in this repo. Copy them to the standard runtime path.

Keep the canonical Codex settings in this repo. Copy the settings and shared
global instructions to the standard Codex runtime path.

For a new app, store its config in this repo and use the app's native include
command in its standard config file. Do not use a symlink. Ask the user if the
app cannot include another file. Update `README.md`.

## Checks

```bash
nu --config ~/.config/nushell/config.nu -c 'print "Nushell config OK"'
python -c 'import tomllib; tomllib.load(open(".codex/config.toml", "rb"))'
python -m json.tool .prime/agent/settings.json >/dev/null
python -m json.tool .prime/agent/models.json >/dev/null
python -m json.tool .prime/agent/themes/github-light-default.json >/dev/null
git diff --check
git status --short
```

Review staged files for secrets. Push to `origin/main` unless told otherwise.
Do not rewrite published history without permission.
