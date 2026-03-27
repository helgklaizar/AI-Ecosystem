---
description: Rapid UI generation and programmable design
---

# AI UI Prototyping (Stitch-SDK style)

**When to use:** During frontend development, landing page creation, or UI component design when a rapid, production-ready, and beautiful result is required without manual styling out of the box.

## AI Instructions
1. Never write raw, ugly HTML with default browser styles!
2. Generate **fully finished, responsive components**.
3. **Tech Stack:** 
   - Clean HTML + **Tailwind CSS**.
   - Do not request external CSS files unless strictly defined by the architecture (rely on Tailwind utility classes).
   - Inject inline SVG icons (e.g., Lucide) and beautiful placeholder images to achieve an "App Store" quality finish.
4. **Iterations:** Always output complete blocks (an entire section or page) rather than fragmented divs, allowing the PM or Engineer to visually validate the design instantly.
5. **Backend Integration:** Design the components with clear separation of structure and state (ready to accept React/Next.js props from an API) without requiring a complete rewrite.
