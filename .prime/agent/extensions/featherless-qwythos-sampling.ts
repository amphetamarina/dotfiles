import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

const MODEL_ID = "empero-ai/Qwythos-9B-Claude-Mythos-5-1M";

export default function (prime: ExtensionAPI) {
  prime.on("before_provider_request", (event) => {
    const payload = event.payload as Record<string, unknown>;

    if (payload.model !== MODEL_ID) {
      return;
    }

    return {
      ...payload,
      do_sample: true,
      temperature: 0.6,
      top_p: 0.95,
      top_k: 20,
      repetition_penalty: 1.05,
    };
  });
}
