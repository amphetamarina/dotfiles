# Helix quick reference

- **Open:** `Space t`
- **Close this pane:** `:q`
- **Show all commands:** `Space ?`

Helix uses **select, then act**. A motion selects text. An edit command acts on the selection.

## Modes

| Key | Action |
|---|---|
| `Esc` | Return to Normal mode |
| `i` / `a` | Insert before / after the selection |
| `I` / `A` | Insert at the start / end of the line |
| `o` / `O` | Add a line below / above |
| `v` | Enter Select mode. Motions now extend the selection |

## Move and select

| Key | Action |
|---|---|
| `h` `j` `k` `l` | Move left, down, up, right |
| `gh` | Move to the beginning of the line |
| `gl` | Move to the end of the line |
| `w` / `b` | Select to the next / previous word |
| `e` | Select to the end of the word |
| `W` `B` `E` | Move by whitespace-separated words |
| `f<char>` | Select through the next `<char>` |
| `t<char>` | Select up to the next `<char>` |
| `x` | Select the current line. Repeat to add lines |
| `%` | Select the complete file |
| `;` | Collapse the selection to one cursor |
| `Alt-;` | Reverse the selection direction |

## Edit the selection

| Key | Action |
|---|---|
| `d` | Delete |
| `c` | Delete and enter Insert mode |
| `r<char>` | Replace selected characters with `<char>` |
| `R` | Replace with copied text |
| `y` | Copy |
| `p` / `P` | Paste after / before |
| `Space y` | Copy to the system clipboard |
| `Space p` / `Space P` | Paste from the system clipboard |
| `u` / `U` | Undo / redo |
| `.` | Repeat the last insertion |
| `>` / `<` | Indent / unindent |

## Search and replace

| Key | Action |
|---|---|
| `/text Enter` | Search forward |
| `?text Enter` | Search backward |
| `n` / `N` | Go to the next / previous match |
| `s` | Select regex matches inside the current selection |
| `*` | Search for the current selection |

**Change one word:** `e c`, type the replacement, then press `Esc`.

**Replace in the complete file:**

1. Press `%` to select the file.
2. Press `s` and enter the search pattern.
3. Press `Enter`, then press `c`.
4. Type the replacement and press `Esc`.

## Multiple selections

| Key | Action |
|---|---|
| `C` / `Alt-C` | Add a cursor on the next / previous suitable line |
| `Alt-s` | Split a multiline selection into one selection per line |
| `,` | Keep only the primary selection |
| `&` | Align all selections |

All edits apply to all active selections at the same time.

## Files

| Key | Action |
|---|---|
| `:w` | Save |
| `:q` | Close the current pane or quit |
| `:wq` | Save and quit |
| `Space f` | Open the file picker |
| `Space b` | Open the buffer picker |
| `Space /` | Search in project files |

## Useful workflows

- **Change a word:** `e c new text Esc`
- **Delete a line:** `x d`
- **Copy a line:** `x y p`
- **Extend a selection:** `v`, then use movement keys
- **Edit repeated text:** select a range, press `s`, enter a pattern, then press `c`
- **Recover from a mistake:** press `u`
