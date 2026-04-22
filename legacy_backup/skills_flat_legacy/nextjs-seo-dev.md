# Nextjs Seo Dev Coding Standards

This skill provides language, framework, and tooling rules.

Always add helpful comments to the code explaining what you are doing.Never delete old comments, unless they are no longer relevant because the code has been rewritten or deleted.This is the package.json file for the nextjs app.Whenever you see a line with this following comment, do not touch it, rewrite it, or delete it "Do not touch this line Antigravity"{"name": "@se-2/nextjs","private": true,"version": "0.1.0","scripts": {"dev": "next dev","start": "next dev","build": "next build","serve": "next start","lint": "next lint","format": "prettier --write . '!(node_modules|.next|contracts)/*/'","check-types": "tsc --noEmit --incremental","vercel": "vercel","vercel:yolo": "vercel --build-env NEXT_PUBLIC_IGNORE_BUILD_ERROR=true"},"dependencies": {"@heroicons/react": "^2.0.11","@rainbow-me/rainbowkit": "2.1.2","@tanstack/react-query": "^5.28.6","@uniswap/sdk-core": "^4.0.1","@uniswap/v2-sdk": "^3.0.1","blo": "^1.0.1","burner-connector": "^0.0.8","daisyui": "4.5.0","next": "^14.0.4","next-themes": "^0.2.1","nprogress": "^0.2.0","qrcode.react": "^3.1.0","react": "^18.2.0","react-copy-to-clipboard": "^5.1.0","react-dom": "^18.2.0","react-hot-toast": "^2.4.0","use-debounce": "^8.0.4","usehooks-ts": "^2.13.0","viem": "2.17.4","wagmi": "2.10.10","zustand": "^4.1.2"},"devDependencies": {"@trivago/prettier-plugin-sort-imports": "^4.1.1","@types/node": "^17.0.35","@types/nprogress": "^0","@types/react": "^18.0.9","@types/react-copy-to-clipboard": "^5.0.4","@typescript-eslint/eslint-plugin": "^5.39.0","abitype": "1.0.5","autoprefixer": "^10.4.12","eslint": "^8.15.0","eslint-config-next": "^14.0.4","eslint-config-prettier": "^8.5.0","eslint-plugin-prettier": "^4.2.1","postcss": "^8.4.16","prettier": "^2.8.4","tailwindcss": "^3.4.3","type-fest": "^4.6.0","typescript": "5.5.3","vercel": "^32.4.1"}}

# Next.js SEO Dev .GEMINI.md prompt file

Author: Rostyslav

## What you can build
Next.js Project Boilerplate Generator - A tool that allows developers to quickly generate a Next.js project with predefined configurations, dependencies, and scripts as seen in the package.json file, helping them kick-start their development process efficiently.Dependency Management Dashboard - A web application that provides insights into your project's dependencies, including version updates, potential vulnerabilities, and dependency tree visualization based on a package.json file.Automated Script Tester - An app that dynamically tests NPM scripts defined in a package.json file to verify their functionality, providing users with a report of any issues or potential optimizations.Code Comment Validator - A service that analyzes code comments in a project to ensure they are comprehensive and up-to-date, especially focusing on areas where code has changed and might need new comments.Next.js Module Updater - A service that automatically checks for the latest versions of Next.js modules and dependencies and offers module update suggestions, ensuring your project always has the latest features and security patches.Prettier & ESLint Configuration App - A web tool that allows users to easily configure Prettier and ESLint for their Next.js projects through an intuitive UI, updating their package.json and other related files.Custom Script Builder - A web application that aids in creating custom NPM scripts tailored to a project's needs, allowing users to expand the functionality defined in their package.json file.TSLint to ESLint Converter - A service that helps convert TSLint configurations to ESLint configurations, focusing on TypeScript projects that need to align with Next.js and modern JS standards.React Component Library Integrator - A tool designed to help integrate popular React component libraries such as DaisyUI or Heroicons into a Next.js project by automatically configuring dependencies and setting up sample components.Version Conflict Resolver - An application that identifies and resolves version conflicts among dependencies listed in a package.json file, ensuring smooth installations and builds.

## Benefits


## Synopsis
Developers maintaining a Next.js app can benefit by ensuring consistent code documentation and version management while adhering to specific guidelines and preserving critical comments.

## Overview of .GEMINI.md prompt
1. The .GEMINI.md file provides instructions for maintaining a package.json file associated with a Next.js app. It emphasizes adding helpful comments to the code and advises against altering lines with specific comments. The package.json file specifies the app's name, version, scripts for building and running the application, and its dependencies and devDependencies, which include various libraries and tools such as Next.js, React, TypeScript, ESLint, and TailwindCSS. Additionally, there are configurations for handling vercel deployments and script commands for development and production builds.





`🔄 **Context:** [Agent: Current] | [Skill: nextjs-seo-dev] | [Workflow: Current]`
