---
name: agent-browser
description: Use agent-browser for website navigation, forms, clicks, screenshots, data extraction, web application tests, and other browser automation tasks.
compatibility: Requires agent-browser in PATH. This workspace provides it through mise.
---

# Agent Browser

Use `agent-browser` for browser automation.

Before you use it, load the current workflow from the installed CLI:

```bash
agent-browser skills get core
```

Use the full reference when the task needs more details:

```bash
agent-browser skills get core --full
```

Use a specialized skill when necessary:

```bash
agent-browser skills list
agent-browser skills get electron
agent-browser skills get slack
agent-browser skills get dogfood
```

Use this basic workflow:

1. Run `agent-browser open <url>`.
2. Run `agent-browser snapshot -i`.
3. Use element references such as `@e1` with `click` or `fill`.
4. Take a new snapshot after the page changes.
5. Run `agent-browser close` when the task is complete.

If `agent-browser` is not in `PATH`, tell the user to start Pi inside
`~/workspace`. Do not install another global copy.

Source: https://github.com/vercel-labs/agent-browser#usage-with-ai-agents
