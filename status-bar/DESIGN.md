---
name: "Antigravity Bar Design"
version: "1.0.0"
description: "Native macOS Menu Bar utility style guide"
colors:
  background: "#1c1c1e"
  surface: "#2c2c2e"
  text-label: "#ffffff"
  text-secondary: "#ebebf5"
  accent: "#007aff"
typography:
  system-ui:
    fontFamily: ".AppleSystemUIFont"
    fontSize: "13px"
  monospace:
    fontFamily: "SF Mono"
    fontSize: "12px"
spacing:
  xs: "4px"
  sm: "8px"
  md: "12px"
  lg: "16px"
rounded:
  popover: "10px"
  button: "5px"
components:
  menu-icon:
    width: "18px"
    height: "18px"
  popover:
    backgroundColor: "{colors.background}"
    rounded: "{rounded.popover}"
    padding: "{spacing.lg}"
---

## 🏛 Overview
Antigravity Bar is a **Native macOS Menu Bar utility**. It must follow the **Apple Human Interface Guidelines (HIG)** strictly but with a "Pro" flair. The default state aligns with the deep dark grey of macOS dark mode.

## 📏 Layout
- **Menu Bar Icon**: 18x18px or 22x22px template image.
- **Popover**: Fixed width, responsive height. Uses standard macOS padding.

## ✅ Do's
- Use **SF Symbols** for all icons natively.
- Support **Dark and Light mode** automatically via system colors where possible, gracefully falling back to specified HEX tokens if custom drawing is required.
- Maintain a **"Clean & Native"** look.

## ❌ Don'ts
- **No custom colors** that clash with macOS system themes.
- **No non-standard rounding** (use system default for popovers).
- **No unnecessary animations** that consume CPU/GPU.
