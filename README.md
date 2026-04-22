# 🌍 AI Ecosystem & Antigravity Bar

> **The ultimate native macOS hub and command center for AI-driven development.**

## 🎯 The Architecture: Global Database vs Local System

To understand how this project works, you must understand the two-tier architecture:

1. **The Global Database (This Repository):**
   `AI-Ecosystem` on GitHub acts as the master database. It contains over 1,800+ specialized skills, agents, and global workflows. It is beautifully documented and constantly updated, but **you should not install all of them**.
   
2. **Your Local System (`~/.gemini/antigravity/`):**
   This is your native Antigravity IDE environment. It is tailored **specifically to you**. Instead of being bloated with thousands of files, it only contains the exact tools you need for your current project stack (e.g., Swift, Next.js, Python), ensuring maximum IDE speed and AI context relevance.

## ⚡ The Antigravity Bar (Status Bar App)

This project includes a native macOS menu bar application called the **Antigravity Bar**, which acts as the bridge between the Global Database and your Local System.

**What does it do?**
- **Native Quick Access**: Dropdown access to your local Agents, Skills, and Workflows.
- **Ecosystem Syncing**: One click pulls the latest updates from the global GitHub database directly into your local machine.
- **👤 My Ecosystem Profile**: A dynamic configuration file (`PROFILE.md`) that stores your name, profession, tech stack, and the list of skills downloaded specifically for you.

## 🚀 First-Time Onboarding & Installation

Do not manually copy folders. Instead, let the AI configure your system:

1. Open **Antigravity** (your native IDE).
2. Ask the AI to read the Onboarding script:
   > *"Please read `AI_ONBOARDING.md` from the `helgklaizar/AI-Ecosystem` repository and configure my system."*
3. The AI will ask you about your profession and tech stack.
4. The AI will cross-reference the **[Ecosystem Guide (ECOSYSTEM_GUIDE.md)](ECOSYSTEM_GUIDE.md)**.
5. Finally, the AI will pull **ONLY** the relevant skills from this global database into your local `~/.gemini/antigravity/` folders and generate your `PROFILE.md`.

## 🧠 Documentation Links

- 📖 **[The Ecosystem Guide](ECOSYSTEM_GUIDE.md)** — The curated list of the most valuable stacks to pull from the database.
- 🚀 **[The Onboarding Script](AI_ONBOARDING.md)** — AI agent instructions for analyzing your system and generating your Profile.
- 🏗️ **[Base Architecture](base/STRUCTURE.md)** — Project structuring rules for new repos.
- 🖥️ **[Antigravity Bar Source](antigravity-bar/README.md)** — Source code for the native macOS status bar plugin.

---

## 📄 License
MIT
