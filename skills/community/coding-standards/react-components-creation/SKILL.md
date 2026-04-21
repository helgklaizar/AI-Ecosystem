# React Components Creation Coding Standards

This skill provides language, framework, and tooling rules.

# Cursor Rules## Whenever you need a React component1. Carefully consider the component's purpose, functionality, and design2. Think slowly, step by step, and outline your reasoning3. Check if a similar component already exists in any of the following locations  1. packages/ui/src/components  2. apps/spa/src/components4. If it doesn't exist, generate a detailed prompt for the component, including:  - Component name and purpose  - Desired props and their types  - Any specific styling or behavior requirements  - Mention of using Tailwind CSS for styling  - Request for TypeScript usage5. URL encode the prompt.6. Create a clickable link in this format:  [ComponentName](https://v0.dev/chat?q={encoded_prompt})7. After generating, adapt the component to fit our project structure:  - Import   - common shadcn/ui components from <ui_package_alias>@repo/ui/components/ui/</ui_package_alias>   - app specific components from <app_package_alias>@/components</app_package_alias>  - Ensure it follows our existing component patterns  - Add any necessary custom logic or state managementExample prompt template:"Create a React component named {ComponentName} using TypeScript and Tailwind CSS.It should {description of functionality}. Props should include {list of props with types}.The component should {any specific styling or behavior notes}. Please provide the full component code."Remember to replace placeholders like <ui_package_path> and <app_package_alias> with the actual values used in your project.

# React Components Creation .cursorrules prompt file

Author: austinm911

## What you can build
Component Repository Manager - An app that helps developers easily search, browse, and manage a repository of existing React components, with integrated identification for reused components across multiple projects and a system to prevent duplication of similar components.Prompt Generator Tool - A web app designed to assist developers by automatically generating detailed prompts for new React components, taking into account existing components, required props, and design specifications while ensuring alignment with project patterns.Component Creation Assistant - A service that provides step-by-step guidance in creating new React components by analyzing project needs, generating clear prompt templates, and offering integration assistance with frequently used libraries like Tailwind CSS and TypeScript.Style and Component Linter - A tool that automatically analyzes React components within a codebase to ensure they meet styling and functionality requirements, suggesting improvements based on project patterns and conventions.UI Component Encyclopedia - A website containing comprehensive documentation of common UI components and their implementations, tailored for teams using React and Tailwind CSS, along with best practice guidelines for adapting components to specific project structures.React Component Sharing Platform - A collaboration-focused platform where developers can share, review, and collaborate on React components, highlighting compatibility with TypeScript and Tailwind CSS, with options for direct integration into existing projects.Dynamic Component URL Encoder - An app that allows developers to generate URL-encoded prompts for sharing detailed React component requests, with the ability to directly integrate the encoded links into project management tools and code repositories.Design-to-Component Service - A service that transforms design mockups and specifications into fully functional React components, complete with typed props and Tailwind CSS styling, following a structured prompt creation process to ensure accurate component output.Interactive Component Documentation Tool - A web app offering an interactive interface to explore and document React components, enabling developers to attach detailed prompts, styling notes, and integration paths directly within the documentation environment.

## Benefits


## Synopsis
Frontend React developers can use this prompt to efficiently create new components, ensuring consistency, TypeScript usage, and Tailwind CSS compliance within their projects.

## Overview of .cursorrules prompt
The .cursorrules file provides a structured methodology for creating new React components within a project. It guides developers to first evaluate the necessity of a new component by reviewing existing components in specified directories. If a new component is needed, it instructs on generating a detailed prompt, focusing on naming, purpose, props, styling using Tailwind CSS, and TypeScript. The prompt is then URL encoded and formatted into a clickable link for further actions. The file also emphasizes adapting the new component to fit the existing project structure, importing necessary common and app-specific components, and following established patterns, with room for custom logic or state management if needed.





`🔄 **Context:** [Agent: Current] | [Skill: react-components-creation] | [Workflow: Current]`
