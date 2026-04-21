---
name: tg-news-summary-fallback
description: Handle failures in local AI filtering during news generation by performing manual summary from raw data dumps.
model: sonnet
---

# Telegram News Summary Fallback

Use this skill when the `generate_news_feed.py` script fails at the [4/5] stage (AI filtering) due to model output instability or context length issues.

## Behavior

1. **Dump Raw Data**: Modify the generation script to save `top_posts` to a `raw_top_posts.json` if the model fails to return valid JSON.
2. **Manual Summary**: Read the generated `raw_top_posts.json` directly.
3. **Categorization**: Group the news by themes (e.g., Anthropic Updates, OpenAI, Local Tools, Research).
4. **Markdown Formatting**: Provide a concise summary with headlines for each news item directly in the chat.

## Rules

- **Don't wait for the local model** if it shows signs of "dot-looping" or garbage output.
- **Ensure raw news content is preserved** before any AI-driven transformation fails.
- **Prioritize speed and readability** over the automated JSON feed if accuracy is compromised.

## Output

A well-structured markdown summary of the latest news provided in the user's Chat interface.

---
*Created via Antigravity Experience Distillation*
