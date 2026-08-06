---
name: exa
description: Search the web through the Exa hosted MCP server. Use for all web searches, current information, source discovery, and technical research.
---

# Exa MCP

The prepared `exa` module connects to the hosted Exa MCP server.

For web search, call:

```python
results = await exa.web_search_exa(query="your search query")
```

Call `await exa.list_tools()` before using an unfamiliar tool or argument.
Use `help(exa.web_search_exa)` after tool discovery to inspect its schema.

The integration requires `EXA_API_KEY` in the Prime Agent environment. The
machine-local Nushell `secrets` file supplies this variable. Do not put the key
in Prime Agent settings or tracked files.
