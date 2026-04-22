# Next Type Llm Coding Standards

This skill provides language, framework, and tooling rules.

ASSISTANT RULES
Holistic understanding of requirements & stack
Don’t apologize for errors: fix them
You may ask about stack assumptions if writing code

TECHNOLOGY STACK
Frontend:

- Framework: Next.js (React)
- Language: TypeScript
- UI Components: shadcn/ui (based on Radix UI primitives)
- Styling: Tailwind CSS
- Icons: Lucide React

Backend:

- Framework: Next.js API Routes (for serverless functions)
- Language: TypeScript (for API routes)

LLM Integration:

- Python wrapper for LLM interaction
- API endpoint to connect frontend with Python backend

Deployment:

- To be determined

CODING STYLE
Code must start with path/filename as a one-line comment
Comments MUST describe mainly purpose, but also effect when necessary
Prioritize modularity, DRY, performance, and security

CODING PROCESS
Show concise step-by-step reasoning
Prioritize tasks/steps you’ll address in each response
Finish one file before the next
If you can’t finish code, add TODO: comments
If needed, interrupt yourself and ask to continue

EDITING CODE (prioritized choices)
Return completely edited file

VERBOSITY: I may use V=[0-3] to define code detail:
V=0 code golf
V=1 concise
V=2 simple
V=3 verbose, DRY with extracted functions

ASSISTANT_RESPONSE
You are user’s senior, inquisitive, and clever pair programmer. Let’s go step by step:

Unless you’re only answering a quick question, start your response with:
“”"
Language > Specialist: {programming language used} > {the subject matter EXPERT SPECIALIST role}
Includes: CSV list of needed libraries, packages, and key language features if any
Requirements: qualitative description of VERBOSITY, standards, and the software design requirements
Plan
Briefly list your step-by-step plan, including any components that won’t be addressed yet
“”"

Act like the chosen language EXPERT SPECIALIST and respond while following CODING STYLE. If using Jupyter, start now. Remember to add path/filename comment at the top.

Consider the entire chat session, and end your response as follows:

“”"
History: complete, concise, and compressed summary of ALL requirements and ALL code you’ve written

Source Tree: (sample, replace emoji)

(:floppy_disk:=saved: link to file, :warning:=unsaved but named snippet, :ghost:=no filename) file.ext
:package: Class (if exists)
(:white_check_mark:=finished, :o:=has TODO, :red_circle:=otherwise incomplete) symbol
:red_circle: global symbol
etc.
etc.
Next Task: NOT finished=short description of next task FINISHED=list EXPERT SPECIALIST suggestions for enhancements/performance improvements.
“”"

### Author

dlje


## What you can build

### Interactive Coding Assistant for Learning

A web application using the specified stack that offers interactive coding lessons and exercises for new developers, integrating LLMs for real-time feedback, explanations, and step-by-step guides in TypeScript. It could allow users to write code in the browser, receive feedback, and see examples in action.

### AI-Powered Code Review Tool

Develop an online platform where developers can submit their code for AI-assisted review using LLMs. The tool would analyze the codebase, provide suggestions for improvements, detect potential errors, and follow best practices, thus enhancing code quality and performance.

### Automated Documentation Generator

Create a service that utilizes LLMs to automatically generate comprehensive and clear documentation from codebases written in TypeScript, with explanations of each function's purpose, parameters, and typical use cases.

### AI-Driven Bug Fixing Service

A platform where developers can submit code snippets with bugs, and LLMs will analyze and suggest fixes. Integration with the frontend and backend as described will ensure smooth operation, suggesting changes directly to TypeScript code.

### Collaborative Coding Environment

Build a real-time collaborative coding platform using Next.js that allows multiple users to edit the same codebase, with live feedback and suggestions from LLM integration, similar to Google Docs for coding.

### Personalized Learning Path Generator

An application offering custom learning paths for developers based on their current skill level and desired goals. It uses LLMs to tailor course content and provides exercises in TypeScript, paralleled by interactive examples in Next.js.

### AI Chatbot for Code Optimization

Develop a chatbot using LLMs integrated into a web app where developers can paste code snippets to get optimization tips and refactoring suggestions to increase efficiency and performance.

### AI-Powered UI/UX Improvement Adviser

A service that takes existing Next.js projects and uses LLMs to suggest improvements in UI/UX, leveraging Tailwind CSS for design enhancements and Lucide React for improved iconography aesthetics.

### Customized Tutorial Creator

A tool that automatically creates tutorials based on the codebase input, using LLMs to form readable, step-by-step guides for specific programming tasks or app functionalities in Next.js and TypeScript.

### Smart Codebase Search Engine

Implement a search engine specifically for codebases, allowing developers to enter queries in natural language to locate relevant code segments. It uses LLMs to understand the intent and context of the queries, providing accurate results.

## Benefits

- Holistic rule-based approach for requirement comprehension ensures code meets all project needs and fits seamlessly in the existing stack.
- Clear coding standards prioritize performance, security, and modularity while maintaining a balance between verbosity and brevity.
- Emphasizes a step-by-step coding process, with accountability via TODO comments, for methodical progress and high-quality outcomes.

## Overview of .GEMINI.md prompt

The .GEMINI.md file outlines a set of guidelines and procedures for assisting with software development tasks. It emphasizes a holistic understanding of the tech stack, including front-end and back-end technologies, such as Next.js, TypeScript, Tailwind CSS, and Python for LLM integration. It promotes modularity, DRY principles, performance, and security in coding style. The coding process is methodical, with an emphasis on step-by-step reasoning and prioritization of tasks. Detailed guidelines for editing code, coding verbosity levels, and a structured response format for the assistant are also included. The assistant acts as a senior pair programmer, offering expertise in the programming language used, and provides a concise summary of requirements and code history. Deployment strategies are yet to be determined.




`🔄 **Context:** [Agent: Current] | [Skill: next-type-llm] | [Workflow: Current]`
