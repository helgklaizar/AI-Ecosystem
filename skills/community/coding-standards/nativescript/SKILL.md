# Nativescript Coding Standards

This skill provides language, framework, and tooling rules.

---
description: Applies general NativeScript best practices.
globs: **/*.tsx, **/*.ts, **/*.vue, **/*.svelte, src/**/*.ts, app/**/*.ts, src/**/*.tsx, app/**/*.tsx, src/**/*.vue, app/**/*.vue, src/**/*.svelte
---
- Organize code using modular components and services for maintainability.
- Use platform-specific files (`.ios.ts`, `.android.ts`) when code exceeds 20 platform-specific lines.
- When creating custom native code, use a folder structure like `custom-native/index.ios.ts`, `custom-native/index.android.ts`, `custom-native/common.ts`, `custom-native/index.d.ts` to keep platform-specific code organized and easy to import with single import elsewhere, replacing `custom-native` with the name of the custom code.
- Prefix platform-specific variables with `ios` or `android` (e.g., `iosButtonStyle`).
- Name custom components and styles descriptively (`primaryButtonStyle`, `userProfileView`).
- Use `@NativeClass()` when extending native classes when needed
- For iOS, when extending native classes, always use `static ObjCProtocols = [AnyUIKitDelegate];` to declare custom delegates if a delegate is required or used.
- For iOS, always retain custom delegate instances to prevent garbage collection. For example, `let delegate = MyCustomDelegate.new() as MyCustomDelegate`, and ensure it is retained in the class scope.
- Favor `__ANDROID__` and `__APPLE__` for conditional platform code with tree-shaking.
- Track and clean up all timers (`setTimeout`, `setInterval`) to avoid memory leaks.
- Always TailwindCSS as the CSS Framework using `"@nativescript/tailwind": "^2.1.0"` for consistent styling paired with `"tailwindcss": "~3.4.0"`.
- Add ios: and android: style variants for platform-specific styling, addVariant('android', '.ns-android &'), addVariant('ios', '.ns-ios &');
- darkMode: ['class', '.ns-dark']
- Leverage `GridLayout` or `StackLayout` for flexible, responsive layouts. Place more emphasis on proper GridLayout usage for complex layouts but use StackLayout for simpler, linear arrangements.
- Use `visibility: 'hidden'` for elements that should not affect layout when hidden.
- Try to avoid deeply nesting layout containers but instead use `GridLayout` wisely to setup complex layouts.
- Avoid direct manipulation of the visual tree during runtime to minimize rendering overhead.
- Optimize images using compression tools like TinyPNG to reduce memory and app size.
- Clean the project (`ns clean`) after modifying files in `App_Resources` or `package.json`.
- Reuse components and styles to avoid duplication.
- Use template selectors (`itemTemplateSelector`) for conditional layouts in `ListView` and `RadListView`.
- Minimize heavy computations in UI bindings or methods.
- Only if using plain xml bindings, use `Observable` or `ObservableArray` properties to reflect state changes efficiently.
- When using Angular, React, Solid, Svelte or Vue, always leverage their respective state management, lifecycle hooks, rendering optimizations and reactive bindings for optimal performance.


---
description: Provides additional instructions for NativeScript development, such as using TypeScript, secure storage and biometrics for sensitive data, nativescript-fonticon for font icons.
globs: **/*.tsx, **/*.ts, **/*.vue, **/*.svelte, src/**/*.ts, app/**/*.ts, src/**/*.tsx, app/**/*.tsx, src/**/*.vue, app/**/*.vue, src/**/*.svelte
---
- Use TypeScript for type safety
- Use @nativescript/secure-storage for sensitive data
- Use @nativescript/biometrics for anything related to biometrics
- Always use nativescript-fonticon for font icons
- Follow NativeScript best practices for performance

// NativeScript .cursorrules

// NativeScript best practices

const nativeScriptBestPractices = [
  "Utilize @nativescript/core features and APIs where applicable",
  "Utilize common web APIs where applicable",
  "Implement proper navigation using NativeScript Navigation",
  "Use NativeScript's assets folder for images, sounds or videos and use the fonts folder for custom fonts",
  "Implement proper error handling where possible"
];

// Folder structure

const folderStructure = `
src/
  assets/
  components/
  services/
  utils/
`;

// Additional instructions

const additionalInstructions = `
1. Use TypeScript for type safety
2. Use @nativescript/secure-storage for sensitive data
3. Use @nativescript/biometrics for anything related to biometrics
4. Always use nativescript-fonticon for font icons
5. Follow NativeScript best practices for performance
`;

---
description: Enforces the recommended folder structure for NativeScript projects at the root level, including assets, src, and nativescript.config.ts.
globs: *.*
---
- Ensure the following structure is present at the root of your NativeScript project with the exception of some frameworks which may use `app/` instead of `src/`. The other exception is that in web based editors like StackBlitz or Bolt, the `App_Resources` can be omitted:
  - App_Resources/
    - Android/
    - iOS/
  - src/
    - assets/
    - components/
    - fonts/
    - services/
    - utils/
  - nativescript.config.ts
  - tailwind.config.js




`🔄 **Context:** [Agent: Current] | [Skill: nativescript] | [Workflow: Current]`
