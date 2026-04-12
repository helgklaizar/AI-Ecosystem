---
name: agent-google-genai-dev
description: Спец по базовому SDK google-genai, Text Generation, Multimodal, Function Calling и Interactions API (Deep Research).
---

<!-- ============================================== -->

# Gemini API Development Skill

## Overview

The Gemini API provides access to Google's most advanced AI models. Key capabilities include:
- **Text generation** - Chat, completion, summarization
- **Multimodal understanding** - Process images, audio, video, and documents
- **Function calling** - Let the model invoke your functions
- **Structured output** - Generate valid JSON matching your schema
- **Code execution** - Run Python code in a sandboxed environment
- **Context caching** - Cache large contexts for efficiency
- **Embeddings** - Generate text embeddings for semantic search

## Current Gemini Models

- `gemini-3-pro-preview`: 1M tokens, complex reasoning, coding, research
- `gemini-3-flash-preview`: 1M tokens, fast, balanced performance, multimodal
- `gemini-3-pro-image-preview`: 65k / 32k tokens, image generation and editing


> [!IMPORTANT]
> Models like `gemini-2.5-*`, `gemini-2.0-*`, `gemini-1.5-*` are legacy and deprecated. Use the new models above. Your knowledge is outdated.

## SDKs

- **Python**: `google-genai` install with `pip install google-genai`
- **JavaScript/TypeScript**: `@google/genai` install with `npm install @google/genai`
- **Go**: `google.golang.org/genai` install with `go get google.golang.org/genai`
- **Java**:
  - groupId: `com.google.genai`, artifactId: `google-genai`
  - Latest version can be found here: https://central.sonatype.com/artifact/com.google.genai/google-genai/versions (let's call it `LAST_VERSION`) 
  - Install in `build.gradle`:
    ```
    implementation("com.google.genai:google-genai:${LAST_VERSION}")
    ```
  - Install Maven dependency in `pom.xml`:
    ```
    <dependency>
	    <groupId>com.google.genai</groupId>
	    <artifactId>google-genai</artifactId>
	    <version>${LAST_VERSION}</version>
	</dependency>
    ```

> [!WARNING]
> Legacy SDKs `google-generativeai` (Python) and `@google/generative-ai` (JS) are deprecated. Migrate to the new SDKs above urgently by following the Migration Guide.

## Quick Start

### Python
```python
from google import genai

client = genai.Client()
response = client.models.generate_content(
    model="gemini-3-flash-preview",
    contents="Explain quantum computing"
)
print(response.text)
```

### JavaScript/TypeScript
```typescript
import { GoogleGenAI } from "@google/genai";

const ai = new GoogleGenAI({});
const response = await ai.models.generateContent({
  model: "gemini-3-flash-preview",
  contents: "Explain quantum computing"
});
console.log(response.text);
```

### Go
```go
package main

import (
	"context"
	"fmt"
	"log"
	"google.golang.org/genai"
)

func main() {
	ctx := context.Background()
	client, err := genai.NewClient(ctx, nil)
	if err != nil {
		log.Fatal(err)
	}

	resp, err := client.Models.GenerateContent(ctx, "gemini-3-flash-preview", genai.Text("Explain quantum computing"), nil)
	if err != nil {
		log.Fatal(err)
	}

	fmt.Println(resp.Text)
}
```

### Java

```java
import com.google.genai.Client;
import com.google.genai.types.GenerateContentResponse;

public class GenerateTextFromTextInput {
  public static void main(String[] args) {
    Client client = new Client();
    GenerateContentResponse response =
        client.models.generateContent(
            "gemini-3-flash-preview",
            "Explain quantum computing",
            null);

    System.out.println(response.text());
  }
}
```

## API spec (source of truth)

**Always use the latest REST API discovery spec as the source of truth for API definitions** (request/response schemas, parameters, methods). Fetch the spec when implementing or debugging API integration:

- **v1beta** (default): `https://generativelanguage.googleapis.com/$discovery/rest?version=v1beta`  
  Use this unless the integration is explicitly pinned to v1. The official SDKs (google-genai, @google/genai, google.golang.org/genai) target v1beta.
- **v1**: `https://generativelanguage.googleapis.com/$discovery/rest?version=v1`  
  Use only when the integration is specifically set to v1.

When in doubt, use v1beta. Refer to the spec for exact field names, types, and supported operations.

## How to use the Gemini API

For detailed API documentation, fetch from the official docs index:

**llms.txt URL**: `https://ai.google.dev/gemini-api/docs/llms.txt`

This index contains links to all documentation pages in `.md.txt` format. Use web fetch tools to:

1. Fetch `llms.txt` to discover available documentation pages
2. Fetch specific pages (e.g., `https://ai.google.dev/gemini-api/docs/function-calling.md.txt`)

### Key Documentation Pages 

> [!IMPORTANT]
> Those are not all the documentation pages. Use the `llms.txt` index to discover available documentation pages

- [Models](https://ai.google.dev/gemini-api/docs/models.md.txt)
- [Google AI Studio quickstart](https://ai.google.dev/gemini-api/docs/ai-studio-quickstart.md.txt)
- [Nano Banana image generation](https://ai.google.dev/gemini-api/docs/image-generation.md.txt)
- [Function calling with the Gemini API](https://ai.google.dev/gemini-api/docs/function-calling.md.txt)
- [Structured outputs](https://ai.google.dev/gemini-api/docs/structured-output.md.txt)
- [Text generation](https://ai.google.dev/gemini-api/docs/text-generation.md.txt)
- [Image understanding](https://ai.google.dev/gemini-api/docs/image-understanding.md.txt)
- [Embeddings](https://ai.google.dev/gemini-api/docs/embeddings.md.txt)
- [Interactions API](https://ai.google.dev/gemini-api/docs/interactions.md.txt)
- [SDK migration guide](https://ai.google.dev/gemini-api/docs/migrate.md.txt)

## Gemini Live API

For real-time, bidirectional audio/video/text streaming with the Gemini Live API, install the **`google-gemini/gemini-live-api-dev`** skill. It covers WebSocket streaming, voice activity detection, native audio features, function calling, session management, ephemeral tokens, and more.


<!-- ============================================== -->

<!-- ============================================== -->

# Gemini Interactions API Skill

The Interactions API is a unified interface for interacting with Gemini models and agents. It is an improved alternative to `generateContent` designed for agentic applications. Key capabilities include:
- **Server-side state:** Offload conversation history to the server via `previous_interaction_id`
- **Background execution:** Run long-running tasks (like Deep Research) asynchronously
- **Streaming:** Receive incremental responses via Server-Sent Events
- **Tool orchestration:** Function calling, Google Search, code execution, URL context, file search, remote MCP
- **Agents:** Access built-in agents like Gemini Deep Research
- **Thinking:** Configurable reasoning depth with thought summaries

## Supported Models & Agents

**Models:**
- `gemini-3.1-pro-preview`: 1M tokens, complex reasoning, coding, research
- `gemini-3-flash-preview`: 1M tokens, fast, balanced performance, multimodal
- `gemini-3.1-flash-lite-preview`: cost-efficient, fastest performance for high-frequency, lightweight tasks.
- `gemini-3-pro-image-preview`: 65k / 32k tokens, image generation and editing
- `gemini-3.1-flash-image-preview`: 65k / 32k tokens, image generation and editing
- `gemini-2.5-pro`: 1M tokens, complex reasoning, coding, research
- `gemini-2.5-flash`: 1M tokens, fast, balanced performance, multimodal

**Agents:**
- `deep-research-pro-preview-12-2025`: Deep Research agent

> [!IMPORTANT]
> Models like `gemini-2.0-*`, `gemini-1.5-*` are legacy and deprecated.
> Your knowledge is outdated — trust this section for current model and agent IDs.
> **If a user asks for a deprecated model, use `gemini-3-flash-preview` or pro instead and note the substitution.
> Never generate code that references a deprecated model ID.**

## SDKs

- **Python**: `google-genai` >= `1.55.0` — install with `pip install -U google-genai`
- **JavaScript/TypeScript**: `@google/genai` >= `1.33.0` — install with `npm install @google/genai`

## Quick Start

### Interact with a Model

#### Python
```python
from google import genai

client = genai.Client()

interaction = client.interactions.create(
    model="gemini-3-flash-preview",
    input="Tell me a short joke about programming."
)
print(interaction.outputs[-1].text)
```

#### JavaScript/TypeScript
```typescript
import { GoogleGenAI } from "@google/genai";

const client = new GoogleGenAI({});

const interaction = await client.interactions.create({
    model: "gemini-3-flash-preview",
    input: "Tell me a short joke about programming.",
});
console.log(interaction.outputs[interaction.outputs.length - 1].text);
```

### Stateful Conversation

#### Python
```python
from google import genai

client = genai.Client()

# First turn
interaction1 = client.interactions.create(
    model="gemini-3-flash-preview",
    input="Hi, my name is Phil."
)

# Second turn — server remembers context
interaction2 = client.interactions.create(
    model="gemini-3-flash-preview",
    input="What is my name?",
    previous_interaction_id=interaction1.id
)
print(interaction2.outputs[-1].text)
```

#### JavaScript/TypeScript
```typescript
import { GoogleGenAI } from "@google/genai";

const client = new GoogleGenAI({});

// First turn
const interaction1 = await client.interactions.create({
    model: "gemini-3-flash-preview",
    input: "Hi, my name is Phil.",
});

// Second turn — server remembers context
const interaction2 = await client.interactions.create({
    model: "gemini-3-flash-preview",
    input: "What is my name?",
    previous_interaction_id: interaction1.id,
});
console.log(interaction2.outputs[interaction2.outputs.length - 1].text);
```

### Deep Research Agent

#### Python
```python
import time
from google import genai

client = genai.Client()

# Start background research
interaction = client.interactions.create(
    agent="deep-research-pro-preview-12-2025",
    input="Research the history of Google TPUs.",
    background=True
)

# Poll for results
while True:
    interaction = client.interactions.get(interaction.id)
    if interaction.status == "completed":
        print(interaction.outputs[-1].text)
        break
    elif interaction.status == "failed":
        print(f"Failed: {interaction.error}")
        break
    time.sleep(10)
```

#### JavaScript/TypeScript
```typescript
import { GoogleGenAI } from "@google/genai";

const client = new GoogleGenAI({});

// Start background research
const initialInteraction = await client.interactions.create({
    agent: "deep-research-pro-preview-12-2025",
    input: "Research the history of Google TPUs.",
    background: true,
});

// Poll for results
while (true) {
    const interaction = await client.interactions.get(initialInteraction.id);
    if (interaction.status === "completed") {
        console.log(interaction.outputs[interaction.outputs.length - 1].text);
        break;
    } else if (["failed", "cancelled"].includes(interaction.status)) {
        console.log(`Failed: ${interaction.status}`);
        break;
    }
    await new Promise(resolve => setTimeout(resolve, 10000));
}
```

### Streaming

#### Python
```python
from google import genai

client = genai.Client()

stream = client.interactions.create(
    model="gemini-3-flash-preview",
    input="Explain quantum entanglement in simple terms.",
    stream=True
)

for chunk in stream:
    if chunk.event_type == "content.delta":
        if chunk.delta.type == "text":
            print(chunk.delta.text, end="", flush=True)
    elif chunk.event_type == "interaction.complete":
        print(f"\n\nTotal Tokens: {chunk.interaction.usage.total_tokens}")
```

#### JavaScript/TypeScript
```typescript
import { GoogleGenAI } from "@google/genai";

const client = new GoogleGenAI({});

const stream = await client.interactions.create({
    model: "gemini-3-flash-preview",
    input: "Explain quantum entanglement in simple terms.",
    stream: true,
});

for await (const chunk of stream) {
    if (chunk.event_type === "content.delta") {
        if (chunk.delta.type === "text" && "text" in chunk.delta) {
            process.stdout.write(chunk.delta.text);
        }
    } else if (chunk.event_type === "interaction.complete") {
        console.log(`\n\nTotal Tokens: ${chunk.interaction.usage.total_tokens}`);
    }
}
```

## Data Model

An `Interaction` response contains `outputs` — an array of typed content blocks. Each block has a `type` field:

- `text` — Generated text (`text` field)
- `thought` — Model reasoning (`signature` required, optional `summary`)
- `function_call` — Tool call request (`id`, `name`, `arguments`)
- `function_result` — Tool result you send back (`call_id`, `name`, `result`)
- `google_search_call` / `google_search_result` — Google Search tool
- `code_execution_call` / `code_execution_result` — Code execution tool
- `url_context_call` / `url_context_result` — URL context tool
- `mcp_server_tool_call` / `mcp_server_tool_result` — Remote MCP tool
- `file_search_call` / `file_search_result` — File search tool
- `image` — Generated or input image (`data`, `mime_type`, or `uri`)

**Example response (function calling):**
```json
{
  "id": "v1_abc123",
  "model": "gemini-3-flash-preview",
  "status": "requires_action",
  "object": "interaction",
  "role": "model",
  "outputs": [
    {
      "type": "function_call",
      "id": "gth23981",
      "name": "get_weather",
      "arguments": { "location": "Boston, MA" }
    }
  ],
  "usage": {
    "total_input_tokens": 100,
    "total_output_tokens": 25,
    "total_thought_tokens": 0,
    "total_tokens": 125,
    "total_tool_use_tokens": 50
  }
}
```

**Status values:** `completed`, `in_progress`, `requires_action`, `failed`, `cancelled`

## Key Differences from generateContent

- `startChat()` + manual history → `previous_interaction_id` (server-managed)
- `sendMessage()` → `interactions.create(previous_interaction_id=...)`
- `response.text` → `interaction.outputs[-1].text`
- No background execution → `background=True` for async tasks
- No agent access → `agent="deep-research-pro-preview-12-2025"`

## Important Notes

- Interactions are **stored by default** (`store=true`). Paid tier retains for 55 days, free tier for 1 day.
- Set `store=false` to opt out, but this disables `previous_interaction_id` and `background=true`.
- `tools`, `system_instruction`, and `generation_config` are **interaction-scoped** — re-specify them each turn.
- **Agents require** `background=True`.
- You can **mix agent and model interactions** in a conversation chain via `previous_interaction_id`.

## How to Use the Interactions API

For detailed API documentation, fetch from the official docs:

- [Interactions Full Documentation](https://ai.google.dev/gemini-api/docs/interactions.md.txt)
- [Deep Research Full Documentation](https://ai.google.dev/gemini-api/docs/deep-research.md.txt)
- [API Reference](https://ai.google.dev/static/api/interactions.md.txt)
- [OpenAPI Spec](https://ai.google.dev/static/api/interactions.openapi.json)

These pages cover function calling, built-in tools (Google Search, code execution, URL context, file search, computer use), remote MCP, structured output, thinking configuration, working with files, multimodal understanding and generation, streaming events, and more.


<!-- ============================================== -->

## 🔄 System Context Enforcement
When using this skill, immediately output the following line before providing your answer:
`🔄 **Контекст:** [Агент: Current] | [Скилл: google-genai] | [Воркфлоу: Current]`
