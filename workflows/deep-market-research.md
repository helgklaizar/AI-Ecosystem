---
description: Deep market research and social network analysis before product creation (based on last30days architecture)
---

# Deep Market Research & Trend Analysis

**When to use:** Before drafting the `micro-spec.md` and launching the `plan-ceo.md` stage. Use this to validate hypotheses, analyze competitors, and understand community sentiment.

## AI Execution Logic (Two-Pass Architecture)

Act as a deep community researcher, extracting raw insights from non-obvious sources:

### Pass 1: Broad Sweep
1. Use the `deep-research`, `browser-agent`, or `search_web` tools.
2. Execute parallel searches on the product topic covering the last 30-90 days across:
   - **Reddit** (niche subreddits)
   - **Hacker News (HN)**
   - **X (Twitter) / Bluesky**
   - **YouTube** (recent reviews and tech talks)
3. Extract core pain points of current solutions, highly requested features, and primary competitors.

### Pass 2: Deep Dive
4. Take the competitors and key figures found in Pass 1 and execute targeted searches for their flaws (e.g., `product_name issue`, `site:reddit.com/r/product_name complaints`).
5. If a topic is aggressively discussed across multiple networks, mark it as a **Strong Signal** for implementation in our product.

### Output:
Generate a structured Markdown report containing real user quotes (complaints/wishes), source URLs, and 3 to 5 actionable recommendations to be included in our `micro-spec.md`.
