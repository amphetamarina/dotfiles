# dotfiles

Public, user-scoped configuration files.

System entry-point files are intentionally tiny and source the corresponding
configuration from this repository. Machine-local settings and secrets must not
be committed.

## Managed configuration

- Ghostty: `.config/ghostty/config.ghostty`
- Red: `.config/red/config.toml`
- GNOME input settings: `.config/gnome/apply-input-settings.sh`
- Herdr: `.config/herdr/config.toml`
- Nushell: `.config/nushell/config.nu`
- Pi global instructions, settings, extensions, and skills: `.pi/agent/`
- Prime Agent global instructions, settings, and Exa skill:
  `.pi/agent/AGENTS.md`, `.prime/agent/settings.json`, and
  `.prime/agent/skills/exa/`

## Nushell

Keep the runtime configuration small. Load the canonical configuration from
this repository:

```nu
source ~/Workspace/dotfiles/.config/nushell/config.nu
```

The canonical configuration sets the user `PATH`, editor variables, and the
Herdr configuration path. It also loads the optional, gitignored `secrets`
file. Use Nushell syntax in that file:

```nu
$env.EXAMPLE_API_KEY = "replace-with-a-machine-local-secret"
```

Keep the file private with mode `600`. Keep generated and other machine-local
Nushell files in the runtime directory.

## Ghostty

Keep the runtime configuration small. Load the canonical configuration from
this repository:

```ini
config-file = "/home/amphetamarina/Workspace/dotfiles/.config/ghostty/config.ghostty"
```

The Ghostty configuration uses
[Annotation Mono](https://qwerasd205.github.io/AnnotationMono/).
Install its variable font as `~/.local/share/fonts/AnnotationMono-VF.ttf` and
refresh the user font cache with `fc-cache -f ~/.local/share/fonts`.

## Red

Red 0.3.0 cannot include another configuration file. Copy the canonical file
to Red's standard configuration path:

```bash
install -m 644 .config/red/config.toml ~/.config/red/config.toml
```

Only relative line numbers were selected for migration from Helix. Red 0.3.0
does not support them. The canonical Red configuration is intentionally minimal
until Red adds this feature.

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

## Prime Agent

Prime Agent uses the same global instructions as Pi. Prime Agent cannot load its
settings from a second file. Copy the canonical files to its runtime directory:

```bash
install -m 644 .pi/agent/AGENTS.md ~/.prime/agent/AGENTS.md
install -m 600 .prime/agent/settings.json ~/.prime/agent/settings.json
```

The canonical settings contain portable preferences. `onboardingShown` prevents
a new onboarding prompt after installation. The settings load the committed Exa
MCP skill and use `EXA_API_KEY` from the environment. They disable the bundled
Serper skill. The integration uses Exa's hosted HTTP endpoint because Prime Agent
0.7 does not connect declared stdio servers to kernel skills.

Start a new Prime Agent session from Nushell after you add or change the Exa key.
A resource reload does not change the environment of an existing worker process.
The settings file does not contain the recent model list because that list is
usage history. Do not commit Prime Agent credentials, sessions, logs, caches, or
generated data.
