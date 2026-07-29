import type {
  Api,
  AssistantMessage,
  Context,
  Model,
  SimpleStreamOptions,
} from "@earendil-works/pi-ai"
import { createAssistantMessageEventStream } from "@earendil-works/pi-ai"
import { openAICompletionsApi } from "@earendil-works/pi-ai/compat"
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent"

const PROVIDER_ID = "inception-labs"
const MODEL_ID = "mercury-2"
const streamOpenAICompletions = openAICompletionsApi().streamSimple

function errorMessage(model: Model<Api>, error: unknown): AssistantMessage {
  return {
    role: "assistant",
    content: [],
    api: model.api,
    provider: model.provider,
    model: model.id,
    usage: {
      input: 0,
      output: 0,
      cacheRead: 0,
      cacheWrite: 0,
      totalTokens: 0,
      cost: { input: 0, output: 0, cacheRead: 0, cacheWrite: 0, total: 0 },
    },
    stopReason: "error",
    errorMessage: error instanceof Error ? error.message : String(error),
    timestamp: Date.now(),
  }
}

function withDiffusion(options: SimpleStreamOptions | undefined): SimpleStreamOptions {
  const onPayload = options?.onPayload

  return {
    ...options,
    async onPayload(payload, model) {
      const diffusionPayload =
        typeof payload === "object" && payload !== null
          ? { ...payload, diffusing: true }
          : payload
      return (await onPayload?.(diffusionPayload, model)) ?? diffusionPayload
    },
  }
}

function streamMercuryDiffusion(
  model: Model<Api>,
  context: Context,
  options?: SimpleStreamOptions,
) {
  const stream = createAssistantMessageEventStream()
  const source = streamOpenAICompletions(model, context, withDiffusion(options))

  void (async () => {
    try {
      for await (const event of source) {
        if (event.type === "text_delta") {
          const block = event.partial.content[event.contentIndex]
          if (block?.type === "text") {
            // In diffusion mode, each delta is a complete replacement snapshot.
            block.text = event.delta
          }
        }
        stream.push(event)
      }
      stream.end(await source.result())
    } catch (error) {
      const message = errorMessage(model, error)
      stream.push({ type: "error", reason: "error", error: message })
      stream.end(message)
    }
  })()

  return stream
}

export default function (pi: ExtensionAPI) {
  let isTui = false

  pi.on("session_start", (_event, ctx) => {
    isTui = ctx.mode === "tui"
  })

  pi.on("session_shutdown", () => {
    isTui = false
  })

  pi.registerProvider(PROVIDER_ID, {
    api: "openai-completions",
    streamSimple(model, context, options) {
      if (isTui && model.id === MODEL_ID) {
        return streamMercuryDiffusion(model, context, options)
      }
      return streamOpenAICompletions(model, context, options)
    },
  })
}
