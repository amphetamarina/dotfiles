# dotfiles

Public, user-scoped configuration files.

System entry-point files are intentionally tiny and source the corresponding
configuration from this repository. Machine-local settings and secrets must not
be committed.

## Managed configuration

- GNOME input settings: `.config/gnome/apply-input-settings.sh`
- GNOME screencast conversion: `.config/screencast/screencast-convert.sh` and `.config/systemd/user/screencast-convert.*`
- Herdr: `.config/herdr/config.toml`
- Nushell: `.config/nushell/config.nu`
- Rio: `.config/rio/config.toml`
- Pi global instructions, settings, extensions, and skills: `.pi/agent/`
- Codex settings and shared global instructions: `.codex/config.toml` and
  `.pi/agent/AGENTS.md`
- Prime Agent global instructions, settings, theme, and Exa skill:
  `.pi/agent/AGENTS.md`, `.prime/agent/settings.json`, and
  `.prime/agent/themes/`, `.prime/agent/skills/exa/`

## Workspace tools

Copy the canonical mise configuration into the Workspace directory, then
install the configured tools:

```bash
install -m 644 workspace-setup/mise.toml ~/Workspace/mise.toml
cd ~/Workspace
mise install
```

The configuration installs Node.js, Python, Rust, Nushell, and Herdr. Activate
mise in Bash by adding this line to `~/.bashrc`:

```bash
eval "$(mise activate bash)"
```

Generate the mise module used by Nushell:

```bash
mkdir -p ~/.config/nushell
mise activate nu > ~/.config/nushell/mise.nu
```

### Rio terminal

Install the latest stable Rio release for the current Debian/Ubuntu architecture
and display server:

```bash
./workspace-setup/install-rio.sh
```

The installer rejects drafts and prereleases, downloads the matching official
`.deb`, verifies its SHA-256 digest from GitHub's release metadata, validates the
package identity, and then installs it with APT. It requires `curl` and `jq`.

Rio does not support including another configuration file. Copy the canonical
configuration into its standard runtime location:

```bash
mkdir -p ~/.config/rio
mkdir -p ~/.config/rio/themes
install -m 644 .config/rio/config.toml ~/.config/rio/config.toml
install -m 644 .config/rio/themes/*.toml ~/.config/rio/themes/
```

The configuration uses MonoLisa Code Italic at 16 pt with its script alternates
and full recommended coding-ligature feature set. Rio always uses GitHub Light
Default, regardless of the desktop appearance; SynthWave '84 remains installed
as an optional theme. It is tuned for the high-density 4K display with font
hinting, native Vulkan rendering, Nerd Font symbol mapping, drawable box
characters, and opaque sRGB output.

## Nushell

Keep the runtime configuration small. Load the canonical configuration from
this repository:

```nu
source ~/Workspace/dotfiles/.config/nushell/config.nu
```

After creating the loader and mise module, launch Nushell from the Workspace:

```bash
cd ~/Workspace
mise exec -- nu
```

The canonical configuration sets the user `PATH` and the Herdr configuration
path. It also loads the optional, gitignored `secrets` file. Use Nushell syntax
in that file:

```nu
$env.EXAMPLE_API_KEY = "replace-with-a-machine-local-secret"
```

Keep the file private with mode `600`. Keep generated and other machine-local
Nushell files in the runtime directory.

## Screencast conversion

GNOME records screencasts as WebM. Twitter and X reject WebM uploads. A user
systemd path unit converts each new screencast to an MP4 that Twitter and X
accept.

The conversion runs ffmpeg. It sets 30 fps, even frame dimensions, H.264, and
the yuv420p pixel format. It adds the faststart flag. The path unit converts
each new recording immediately. The timer runs every 5 minutes as a safety
net for recordings the path unit may have missed.

Install the script and the units:

```bash
install -m 755 .config/screencast/screencast-convert.sh ~/.local/bin/screencast-convert.sh
install -m 644 .config/systemd/user/screencast-convert.path ~/.config/systemd/user/
install -m 644 .config/systemd/user/screencast-convert.service ~/.config/systemd/user/
install -m 644 .config/systemd/user/screencast-convert.timer ~/.config/systemd/user/
systemctl --user daemon-reload
systemctl --user enable --now screencast-convert.path
systemctl --user enable --now screencast-convert.timer
```

Convert all existing recordings at any time:

```bash
systemctl --user start screencast-convert.service
```

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

## Codex

Codex uses the portable settings in this repository. It also uses the same
global instructions as Pi and Prime Agent:

```bash
mkdir -p ~/.codex
install -m 600 .codex/config.toml ~/.codex/config.toml
install -m 644 .pi/agent/AGENTS.md ~/.codex/AGENTS.md
```

The Codex CLI reads [user settings](https://developers.openai.com/codex/config-basic/)
from `~/.codex/config.toml` and [global instructions](https://developers.openai.com/codex/guides/agents-md/)
from `~/.codex/AGENTS.md`. The canonical config selects the `inspired-github`
light syntax theme. Start a new Codex session after you change the config or the
global instructions.

## Prime Agent

Prime Agent uses the same global instructions as Pi. Prime Agent cannot load its
settings from a second file. Copy the canonical files to its runtime directory:

```bash
install -m 644 .pi/agent/AGENTS.md ~/.prime/agent/AGENTS.md
install -m 600 .prime/agent/settings.json ~/.prime/agent/settings.json
install -m 600 .prime/agent/models.json ~/.prime/agent/models.json
mkdir -p ~/.prime/agent/themes
install -m 644 .prime/agent/themes/*.json ~/.prime/agent/themes/
```

The canonical settings contain portable preferences. `onboardingShown` prevents
a new onboarding prompt after installation. The settings select the custom
GitHub Light Default theme. The settings load the committed Exa MCP skill and
use `EXA_API_KEY` from the environment. They disable the bundled Serper skill.
The custom model file adds Featherless AI and uses
`FEATHERLESS_API_KEY` from the environment. The model file uses the Featherless
32K hosted context limit. The settings reserve 20K tokens and keep 2K recent
tokens so Prime Agent can compact a long session before a request fails. The
Qwythos request extension enables sampling. It sets `temperature` to 0.6, `top_p`
to 0.95, `top_k` to 20, and `repetition_penalty` to 1.05. Prime Agent maps the
16,384-token output limit to Featherless `max_tokens`. The Exa integration uses
its hosted HTTP endpoint because Prime Agent 0.7 does not connect declared stdio
servers to kernel skills.

Start a new Prime Agent session from Nushell after you add or change either
API key. A resource reload does not change the environment of an existing worker
process.
The settings file does not contain the recent model list because that list is
usage history. Do not commit Prime Agent credentials, sessions, logs, caches, or
generated data.
