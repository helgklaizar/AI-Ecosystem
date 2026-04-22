# Py Fast Api Coding Standards

This skill provides language, framework, and tooling rules.

You are an expert in Python, FastAPI, and scalable API development.

Key Principles

- Write concise, technical responses with accurate Python examples.
- Use functional, declarative programming; avoid classes where possible.
- Prefer iteration and modularization over code duplication.
- Use descriptive variable names with auxiliary verbs (e.g., is_active, has_permission).
- Use lowercase with underscores for directories and files (e.g., routers/user_routes.py).
- Favor named exports for routes and utility functions.
- Use the Receive an Object, Return an Object (RORO) pattern.

Python/FastAPI
 - Use def for pure functions and async def for asynchronous operations.
 - Use type hints for all function signatures. Prefer Pydantic models over raw dictionaries for input validation.
 - File structure: exported router, sub-routes, utilities, static content, types (models, schemas).
 - Avoid unnecessary curly braces in conditional statements.
 - For single-line statements in conditionals, omit curly braces.
 - Use concise, one-line syntax for simple conditional statements (e.g., if condition: do_something()).

Error Handling and Validation
 - Prioritize error handling and edge cases:
  - Handle errors and edge cases at the beginning of functions.
  - Use early returns for error conditions to avoid deeply nested if statements.
  - Place the happy path last in the function for improved readability.
  - Avoid unnecessary else statements; use the if-return pattern instead.
  - Use guard clauses to handle preconditions and invalid states early.
  - Implement proper error logging and user-friendly error messages.
  - Use custom error types or error factories for consistent error handling.

Dependencies
 - FastAPI
 - Pydantic v2
 - Async database libraries like asyncpg or aiomysql
 - SQLAlchemy 2.0 (if using ORM features)

FastAPI-Specific Guidelines
 - Use functional components (plain functions) and Pydantic models for input validation and response schemas.
 - Use declarative route definitions with clear return type annotations.
 - Use def for synchronous operations and async def for asynchronous ones.
 - Minimize @app.on_event("startup") and @app.on_event("shutdown"); prefer lifespan context managers for managing startup and shutdown events.
 - Use middleware for logging, error monitoring, and performance optimization.
 - Optimize for performance using async functions for I/O-bound tasks, caching strategies, and lazy loading.
 - Use HTTPException for expected errors and model them as specific HTTP responses.
 - Use middleware for handling unexpected errors, logging, and error monitoring.
 - Use Pydantic's BaseModel for consistent input/output validation and response schemas.

Performance Optimization
 - Minimize blocking I/O operations; use asynchronous operations for all database calls and external API requests.
 - Implement caching for static and frequently accessed data using tools like Redis or in-memory stores.
 - Optimize data serialization and deserialization with Pydantic.
 - Use lazy loading techniques for large datasets and substantial API responses.

Key Conventions
 1. Rely on FastAPI’s dependency injection system for managing state and shared resources.
 2. Prioritize API performance metrics (response time, latency, throughput).
 3. Limit blocking operations in routes:
   - Favor asynchronous and non-blocking flows.
   - Use dedicated async functions for database and external API operations.
   - Structure routes and dependencies clearly to optimize readability and maintainability.

Refer to FastAPI documentation for Data Models, Path Operations, and Middleware for best practices.


## What you can build

### API Performance Monitoring Tool

A web app that uses FastAPI to track, analyze, and optimize API performance metrics such as response time, latency, and throughput. It will provide real-time dashboards and alerts for performance issues.

### Async API Wrapper Generator

A command-line tool that generates FastAPI-based Python code for interfacing with external APIs. It will automatically include async functions for non-blocking API operations and error-handling patterns.

### Validation and Error Handling Library

A Python library that provides utilities and decorators for consistent error handling and input validation using Pydantic in FastAPI projects. It will focus on guard clauses, custom error types, and error logging.

### Database Interaction Utility

A lightweight Python package that facilitates the use of async database libraries with SQLAlchemy 2.0 in FastAPI, focusing on optimizing query performance and using lazy loading techniques.

### FastAPI Middleware Suite

A collection of pre-built middleware for FastAPI applications focusing on logging, error monitoring, performance optimization, and security enhancements.

### Scalable API Bootstrapping Service

A web-based service that allows users to generate boilerplate code for scalable FastAPI applications, adhering to best practices in API development, modular file structures, and dependency injection patterns.

### Pydantic Schema Generator

A GUI application that generates Pydantic models and schemas from JSON or YAML files, aiding in the consistent use of input/output validation and response schemas in FastAPI projects.

### Cache Management Plugin

A FastAPI plugin that facilitates the integration and management of caching strategies using tools like Redis for optimizing the performance of frequently accessed endpoints.

### Async Workflow Orchestrator

A tool for managing complex async workflows and I/O-bound tasks in FastAPI applications, providing templates and patterns for building robust and non-blocking routes.

### FastAPI Route Optimizer

An IDE plugin or script that reviews FastAPI code to suggest optimizations for route definitions, dependency injection usage, and async operation patterns to enhance readability and performance.

## Overview of .GEMINI.md prompt

The .GEMINI.md file outlines key principles and guidelines for developing scalable APIs using Python and FastAPI. It emphasizes writing concise and technical responses with accurate code examples, adhering to functional programming principles, and employing modular and iterative approaches to reduce code duplication. The file provides detailed instructions on Python/FastAPI usage, including the structure of files and functions, error handling, and dependency requirements. It highlights performance optimization tactics such as using asynchronous operations, caching, and lazy loading. Key conventions include the reliance on FastAPI's dependency injection system, focusing on API performance metrics, and limiting blocking operations. It encourages adherence to FastAPI's best practices for data models, path operations, and middleware.

### Author

Caio Barbieri




`🔄 **Context:** [Agent: Current] | [Skill: py-fast-api] | [Workflow: Current]`
