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
- **Ecosystem Syncing**: Automatically fetches and updates the latest workflows and skills directly from GitHub.
- **👤 My Ecosystem Profile**: A dynamic configuration file (`knowledge/user_ecosystem_profile/artifacts/PROFILE.md`) that tracks your stack and loaded skills.

## 🚀 First-Time Onboarding & Installation

There are two ways to set up your perfectly tailored environment. **Do not manually copy folders.**

### Flow A: Zero-Prompt AI Onboarding (For IDE Users)
1. Open **Antigravity** (your native IDE).
2. Simply drop the repository link into the AI chat:
   `https://github.com/helgklaizar/AI-Ecosystem`
3. The Agent will autonomously find the `AI_ONBOARDING.md`, read the instructions, install the Status Bar, and interactively set up your system based on your stack.

### Flow B: UI-Driven Onboarding (For Visual Setup)
1. Download and launch the **Antigravity Bar** macOS application.
2. A sleek macOS setup wizard will appear.
3. Select your tech stack (e.g., Swift, Next.js, Python).
4. The Status Bar will directly clone the necessary assets from this Global Database into your `~/.gemini/antigravity/` folders.

## 🏛️ Advanced Architectural Pillars

To maintain a pristine and secure environment, the ecosystem relies on the following mechanics managed by the Status Bar:

1. **Context Switching**: The Status Bar detects the active IDE window (e.g., a Swift project vs. a Python backend) and dynamically swaps your active `PROFILE.md` pre-sets to prevent AI context hallucination.
2. **Ecosystem Sync & Updates**: Direct, smart fetching from GitHub. When `AI-Ecosystem` updates globally, the Status Bar prompts you to update your local skills while handling merge conflicts for locally modified files.
3. **Garbage Collection**: Unused skills clutter the AI's context. The Status Bar periodically audits your projects and suggests removing dormant skills (e.g., *"You haven't opened a Next.js project in a month. Remove Next.js skills?"*).
4. **macOS Permissions Management**: The Status Bar elegantly handles requesting required system permissions (Accessibility, Full Disk Access) before attempting to run scripts or build apps.
5. **Security Guardrails**: **Safe Mode** ensures that new, unverified workflows (especially those performing git commits or file deletions) require your explicit approval before the AI can execute them.

## 🧠 Documentation Links

- 📖 **[The Ecosystem Guide](ECOSYSTEM_GUIDE.md)** — The curated list of the most valuable stacks to pull from the database.
- 🚀 **[The Onboarding Script](AI_ONBOARDING.md)** — AI agent instructions for analyzing your system and generating your Profile.
- 🏗️ **[Base Architecture](base/STRUCTURE.md)** — Project structuring rules for new repos.
- 🖥️ **[Antigravity Bar Source](status-bar/README.md)** — Source code for the native macOS status bar plugin.

---

## 📄 License
MIT
