# Instructions for Agents

## Purpose and scope

This is the public dotfiles repository for `amphetamarina`. It contains the
canonical, user-scoped configuration for this machine. Keep configuration in
this repository and leave only minimal loader files at the applications'
standard system paths.

The repository is checked out at:

```text
~/workspace/dotfiles
```

These instructions apply to the entire repository.

## Non-negotiable rules

1. **Never commit secrets.** Do not add API keys, access tokens, passwords,
   credentials, cookies, private keys, authentication files, or machine-local
   secret values. Inspect staged changes before every commit.
2. **Do not use symlinks.** Standard configuration entry points must be regular
   files that source or include the canonical file from this repository.
3. **Do not modify system defaults.** In particular, never edit `/etc/bashrc`.
   The repository's `.bashrc` may source `/etc/bashrc` to retain Fedora's
   defaults.
4. **Edit canonical files here, not loader files.** Loader files should contain
   only the directive needed to load their repository counterpart.
5. **Do not add mise configuration unless explicitly requested.** The
   workspace's mise setup is intentionally outside the current dotfiles scope.
6. Keep this repository safe to publish publicly. Do not add generated caches,
   histories, application databases, session state, or host-specific auth
   files such as `~/.config/gh/hosts.yml`.

## Current loader architecture

### Bash

System entry point:

```bash
# ~/.bashrc
source ~/workspace/dotfiles/.bashrc
```

Canonical configuration:

```text
~/workspace/dotfiles/.bashrc
```

`~/.bash_profile` uses `~/.bashrc` and should not need modification.

### tmux

System entry point:

```tmux
# ~/.tmux.conf
source-file ~/workspace/dotfiles/.tmux.conf
```

Canonical configuration and helpers:

```text
~/workspace/dotfiles/.tmux.conf
~/workspace/dotfiles/.config/tmux/cpu-percent.sh
~/workspace/dotfiles/.config/tmux/memory-percent.sh
```

Keep helper paths in `.tmux.conf` pointed at the repository copies.

### Ghostty

System entry point:

```ini
# ~/.config/ghostty/config.ghostty
config-file = "/home/amphetamarina/workspace/dotfiles/.config/ghostty/config.ghostty"
```

Canonical configuration:

```text
~/workspace/dotfiles/.config/ghostty/config.ghostty
```

## Adding future configurations

When adding another application:

1. Determine whether the application supports a native `source`, `include`, or
   `config-file` directive.
2. Store the complete canonical configuration under the corresponding path in
   this repository, preferably mirroring its normal home-directory path.
3. Replace the normal user entry point with a minimal regular file that loads
   the repository copy.
4. Do not use a symlink. If the application cannot include another file, stop
   and ask the user before choosing an alternative.
5. Update `README.md` and this inventory when appropriate.
6. Validate the configuration and reload the running application when safely
   supported.

## Validation

Use the relevant checks after changes:

```bash
# Bash
bash -n ~/.bashrc
bash -n ~/workspace/dotfiles/.bashrc

# tmux
tmux source-file ~/.tmux.conf

# Ghostty
ghostty +validate-config
```

For Ghostty, reload the running GTK application through its D-Bus action when
available, then inspect `ghostty +show-config`. For tmux, verify important
options with `tmux show-options -g`.

Before committing:

```bash
git status --short
git diff --check
git diff --cached
```

Confirm that no secrets or unrelated generated files are staged. Use clear
commit subjects and explanatory bodies, then push to `origin/main` unless the
user says otherwise. Do not rewrite published history without explicit
permission.
