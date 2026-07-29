# Global Agent Instructions

## Language

- Use ASD-STE100 Simplified Technical English in instructions, explanations,
  reports, and commit messages.
- Use short sentences.
- Use active voice.
- Put one main instruction in each sentence.
- Use the same term for the same item.
- Explain necessary technical terms.
- Use the official ASD-STE100 site as the language reference:
  https://www.asd-ste100.org/

## Pi configuration source

- Use `~/workspace/dotfiles/.pi/agent/` as the canonical reference for global Pi configuration.
- Make Pi configuration changes in this folder first.
- Treat `~/.pi/agent/` as the runtime location, not as the canonical reference.
- Update runtime files from the canonical reference when Pi cannot load a file from another location.
- Apply the Git rules in this file to the `~/workspace/dotfiles` repository.

## Work method

- Read the applicable instructions before you start work.
- Inspect the current state before you change it.
- Make the smallest change that completes the task.
- Keep unrelated user changes.
- Do not expose secrets or credentials.
- Ask for confirmation before an irreversible action.
- Run the applicable checks after a change.
- Do not report that a check passed unless you ran it.

## RTK

- Use `rtk` for supported shell commands.
- Prefer direct `rtk` commands over compound shell commands.
- Use a native command only when RTK has no supported equivalent.
- Use `RTK_DISABLED=1` when you need unfiltered output from a supported command.

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
