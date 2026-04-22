# Manifest Yaml Coding Standards

This skill provides language, framework, and tooling rules.

---
description: 
globs: 
alwaysApply: true
---
**Prompt for Expert Manifest Developer**

**You are an assistant for app creation. You are going to use the backend Manifest. The apps you generate are light and for demo purposes: you not aim to provide all the data structure but instead showcase a variety of property types.**

**Code structure**
When asked to create a backend, execute the following actions:

1. Install the `manifest` npm package
2. Add the following scripts to `pacakge.json`: "manifest": "node node_modules/manifest/scripts/watch/watch.js" and "manifest:seed": "node node_modules/manifest/dist/manifest/src/seed/scripts/seed.js"
3. Create the `manifest/backend.yml` file and add the manifest code to it.
4. Add the `redhat.vscode-yaml` as recommendation in `.vscode/extensions.json`
5. Add the following `yaml.schemas`: `"https://schema.manifest.build/schema.json": "**/manifest/**.yml"` in `.vscode/settings.json`

**Backend file**
On the `manifest/backend.yml`, follow those rules:
- Stricly follow the Manifest JSON Schema: https://schema.manifest.build/schema.json
- Start by addind a quick name to the app
- Limit to 2 or 3 entities maximum
- Limit to 4 properties maximum per entity
- Try to showcase different property types
- Only use validation properties once or twice
- No entity should be called admin
- Do not use authenticable entities
- Add an emoji after each entity name, but do not use the emoji it on relationships references
- Add a linebreak before each entity object
- Each entity only appears once. Relationships goes just below the properties, do not repeat the entity name.
- Do not use special characters.
. Do not use middlewares, endpoints or hooks.
- Use YAML abbreviated form for objects, with spaces. Example: { name: issueDate, type: date }
- Do not add relationships to single entities
- For relationships, use the short form. Ex: ' belongsTo:
      - Author'
- Add policies. Most projects only have "read" public policies. Some projects have "create" public policies when anyone can post (contact forms submissions, comments, etc.)
- If using the "choice" property type, use "options.values" property to list choices. Example:  `{ name: type, type: choice, options: { values: ["Fire", "Water", "Grass"] } }`
- Do not add "seedCount" and "mainProp" to entities

**Documentation**
Refer to the Manifest documentation: https://manifest.build/docs

**Example**
This is an example of the content of a `backend.yml` file:
name: My pet app 🐾
entities:
  Owner:
    properties:
      - name
      - { name: birthdate, type: date }

  Cat:
    properties:
      - name
      - { name: age, type: number }
      - { name: birthdate, type: date }
    belongsTo:
      - Owner

  Homepage:
    nameSingular: Home content
    single: true
    properties:
      - title
      - { name: description, type: richText }
      - { name: cover, type: image }


# Manifest Backend .manifestrules Prompt

## 🚀 What you can build

Fully functional backends with data, storage, and logic—including essential features like auth, custom hooks, and even an admin panel. These backends can be built for a wide range of applications:

- **Blog API:** Manage posts, authors, and comments with rich text, date, and choice fields.

- **Headless CMS Backend:** Provide an API-first content management system with content types, entries, and localization support for decoupled frontends.

- **Contact Form Service:** Collect and list public inquiries with minimal setup and public create policies.

- **Product Catalog:** Store products with images, prices, and categories; demonstrate choice properties and relationships.

- **Event Scheduler:** Handle events, attendees, and RSVPs using date, number, and choice types.

- **Todo List App:** Track tasks, status, and priorities with a public read policy.

- **User Profiles:** Save profile info, avatars, and settings without authentication.

- **Analytics Logger:** Collect event logs with timestamps and metadata for demo dashboards.

- **Feedback Collector:** Public comments service with create and read policies.

- **File Meta Store:** Demo file uploads and metadata tracking (filename, size, type).

- **Interactive Coding Playground:** A backend to store exercises, hints, and user submissions for an AI-driven coding tutor.

- **Feature Flag Manager Backend:** Manage feature flags, release dates, and user group assignments.

- **Survey Engine Backend:** Define surveys, questions, and responses with choice and number types.

## ✨ Benefits

**Seamless AI Integration:** Manifest’s rules-based schema lets LLMs generate valid backend code without manual schema feeding.
**Error Prevention:** Automatic schema and formatting validation catches issues early, saving debugging time.

**Token Efficiency:** Embedding Manifest’s conventions reduces token usage when prompting your AI assistant.

**Rapid Prototyping:** Spin up complete, functional backends with data storage and logic in minutes.

**Frictionless Developer Experience:** Stay in your editor. Code or vibe-code your app without interruptions.

## 📋 Synopsis

This prompt file guides the generation of backends with Manifest. It embeds your rules for file structure, entity generation with property types, relationships, and policies. Use it to drive your LLM to produce concise, valid manifest/backend.yml files.

## References

- Manifest Docs: https://manifest.build/docs

- JSON Schema: https://schema.manifest.build/schema.json




`🔄 **Context:** [Agent: Current] | [Skill: manifest-yaml] | [Workflow: Current]`
