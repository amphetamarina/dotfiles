"""Prime Agent integration for the hosted Exa MCP server."""

from rlm import McpIntegration


class Exa(McpIntegration):
    """Connect to Exa web search through streamable HTTP MCP."""

    server = "exa"
    url = "https://mcp.exa.ai/mcp?tools=web_search_exa"
    bearer_token_env = "EXA_API_KEY"


exa = Exa()

_RESERVED = {"run", "__wrapped__", "__call__"}


def __getattr__(name: str):
    """Forward module attributes to the Exa integration instance."""
    if name.startswith("_") or name in _RESERVED:
        raise AttributeError(name)
    return getattr(exa, name)
