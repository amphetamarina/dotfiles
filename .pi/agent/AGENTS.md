# Global Agent Instructions

## Writing style

- Use the Google developer documentation style guide as the default reference
  for all prose: https://developers.google.com/style
- Apply direct user instructions and project-specific style before this guide.
- For every writing task, apply the relevant guide rules during the draft and
  the final edit.
- Open the applicable current guide page when a rule is unclear or can have
  changed.
- Write for the intended audience. Use clear, concise, and direct language.
- Use active voice, present tense, and second person when they fit the content.
- Put one main idea in each sentence. Keep sentences and paragraphs short.
- Use sentence case for headings. Use the same term for the same item.
- Define unfamiliar abbreviations and necessary jargon. Avoid idioms, slang,
  unnecessary words, and excessive claims.
- Use inclusive, accessible, and global-ready language. Use descriptive link
  text.
- Preserve exact code, commands, identifiers, UI labels, quotations, and legal
  text.
- Depart from the guide only when accuracy, safety, accessibility, direct user
  instructions, or project style requires it. Stay consistent.

## Agent configuration source

- Use `~/Workspace/dotfiles/.pi/agent/` as the canonical reference for shared global instructions and Pi configuration.
- Use `~/Workspace/dotfiles/.codex/config.toml` as the canonical reference for Codex settings.
- Use `~/Workspace/dotfiles/.prime/agent/settings.json` as the canonical reference for Prime Agent settings.
- Use `~/Workspace/dotfiles/.prime/agent/models.json` as the canonical reference for Prime Agent custom models.
- Use `~/Workspace/dotfiles/.prime/agent/extensions/` as the canonical reference for Prime Agent extensions.
- Make agent configuration changes in this repository first.
- Treat `~/.codex/`, `~/.pi/agent/`, and `~/.prime/agent/` as runtime locations.
- Copy canonical files to a runtime location when an agent cannot load them from this repository.
- Apply the Git rules in this file to the `~/Workspace/dotfiles` repository.

## Work method

- Read the applicable instructions before you start work.
- Inspect the current state before you change it.
- Make the smallest change that completes the task.
- Keep unrelated user changes.
- Do not expose secrets or credentials.
- Ask for confirmation before an irreversible action.
- Run the applicable checks after a change.
- Do not report that a check passed unless you ran it.

## Web search

- Always use the Exa MCP `web_search_exa` tool for web searches.
- Call `await exa.web_search_exa(query="...")` from IPython.
- Do not use Serper or another web search provider.
- Do not put `EXA_API_KEY` in tracked files or Prime Agent settings.

## Evidence

- Give inspectable evidence for each factual claim.
- Give inspectable evidence for each reason that supports a decision.
- Use a local file path and line number for source evidence.
- Use command output for runtime evidence.
- Use a direct web link for external evidence.
- Prefer source code, official documentation, and primary sources.
- Identify an inference as an inference.
- State when evidence is not available.
- Do not present an unverified statement as a fact.

## Git

First, use `git rev-parse --is-inside-work-tree` to detect a Git repo.

If the task changes files in a Git repo:

- Inspect `git status` before and after the change.
- Stage only the files that you changed for the task.
- Do not include unrelated user changes.
- Run the applicable tests or validation commands.
- Commit the completed work.
- Use a clear commit subject.
- Use a detailed commit body.
- State what changed.
- State why it changed.
- Cite the evidence for the decision.
- State which checks ran and give the results.
- State useful learnings and cite their evidence.
- Do not add a co-author.
- Do not add a `Co-authored-by` trailer.
- Do not amend or rewrite published history without permission.
- Do not push unless the user asks for a push.

If a commit is not possible, state the reason and show the evidence.

## Final report

At the end of the task, give these items:

- What changed.
- Why it changed.
- Evidence for the claims and decisions.
- Checks that ran and their results.
- The commit hash, if a commit exists.
- Useful learnings and their evidence.

Keep the report concise. Use file paths and web links that the user can inspect.
