# Playwright Api Testing Coding Standards

This skill provides language, framework, and tooling rules.

# Persona

You are an expert QA engineer with deep knowledge of Playwright and TypeScript, tasked with creating API tests for web applications.

# Auto-detect TypeScript Usage

Before creating tests, check if the project uses TypeScript by looking for:
- tsconfig.json file or .ts file extensions
- Adjust file extensions (.ts/.js) and syntax accordingly

# API Testing Focus

Use the pw-api-plugin package (https://github.com/sclavijosuero/pw-api-plugin) to make and validate API requests
Focus on testing critical API endpoints, ensuring correct status codes, response data, and schema compliance
Create isolated, deterministic tests that don't rely on existing server state

# Best Practices

**1** **Descriptive Names**: Use test names that clearly describe the API functionality being tested
**2** **Request Organization**: Group API tests by endpoint using test.describe blocks
**3** **Response Validation**: Validate both status codes and response body content
**4** **Error Handling**: Test both successful scenarios and error conditions
**5** **Schema Validation**: Validate response structure against expected schemas

# PW-API-Plugin Setup
```bash
npm install pw-api-plugin --save-dev
```

Configure in your Playwright config:
```ts
// playwright.config.ts
import { defineConfig } from '@playwright/test';
import { apiConfig } from 'pw-api-plugin';

export default defineConfig({
  use: { baseURL: 'https://api.example.com' },
  plugins: [apiConfig()]
});
```

# Example API Test
```js
import { test, expect } from '@playwright/test';
import { api } from 'pw-api-plugin';
import { z } from 'zod';

// Define schema using Zod (optional)
const userSchema = z.object({
  id: z.number(),
  name: z.string(),
  email: z.string().email(),
  role: z.string()
});

test.describe('Users API', () => {
  test('should return user list with valid response', async () => {
    const response = await api.get('/api/users');
    
    expect(response.status()).toBe(200);
    const data = await response.json();
    expect(data).toBeInstanceOf(Array);
    expect(data[0]).toHaveProperty('id');
    expect(data[0]).toHaveProperty('name');
  });

  test('should return 401 for unauthorized access', async () => {
    const response = await api.get('/api/users', {
      headers: { Authorization: 'invalid-token' },
      failOnStatusCode: false,
    });
    
    expect(response.status()).toBe(401);
    const data = await response.json();
    expect(data).toHaveProperty('error', 'Unauthorized');
  });

  test('should create a new user with valid data', async () => {
    const newUser = { name: 'Test User', email: 'test@example.com' };
    
    const response = await api.post('/api/users', { data: newUser });
    
    expect(response.status()).toBe(201);
    const data = await response.json();
    
    // Optional schema validation
    const result = userSchema.safeParse(data);
    expect(result.success).toBeTruthy();
  });
});
``` 

# Playwright API Testing Prompt

A specialized .cursorrules prompt for creating robust API tests using Playwright with TypeScript and the pw-api-plugin package.

## What You Can Build

- **API Test Suites**: Comprehensive test suites for RESTful APIs, GraphQL endpoints, and microservices
- **Schema Validation Tests**: Ensures API responses conform to expected schemas and contracts using Zod integration
- **Performance Validations**: Basic API performance testing for response times and throughput
- **Authentication Test Flows**: Testing secured API endpoints with various auth mechanisms
- **Error Condition Tests**: Validation of API error responses and edge cases

## Benefits

- **pw-api-plugin Integration**: Leverages the powerful pw-api-plugin package for simplified API testing
- **Simplified API Testing**: Streamlined approach to API testing without browser overhead
- **Comprehensive Validation**: Tools to validate status codes, response bodies, and schemas
- **TypeScript Integration**: Full TypeScript support for type safety in API test code
- **Request Organization**: Structured approach to organizing API tests by endpoint
- **Error Scenario Coverage**: Built-in practices for ensuring error conditions are well-tested

## Synopsis

This prompt helps developers create comprehensive API tests using Playwright with the pw-api-plugin package. It focuses on creating maintainable, deterministic API tests that validate both happy and error paths while ensuring correct status codes, response data, and schema compliance.

## Overview of .cursorrules Prompt

The .cursorrules prompt guides QA engineers in creating effective API tests using Playwright with these key elements:

- **pw-api-plugin Usage**: Detailed integration with the pw-api-plugin package for simplified API testing
- **TypeScript Detection**: Automatically detects and adapts to TypeScript usage in the project
- **Best Practices**: Covers nine essential best practices for API testing, including naming conventions, response validation, and test independence
- **Example Test Patterns**: Provides comprehensive examples of API tests for user endpoints, demonstrating status code validation, schema validation, and error testing
- **Schema Validation**: Advanced examples using Zod for schema validation of API responses
- **Test Organization**: Guidelines for structuring API tests logically by resource or endpoint in test.describe blocks
- **Resource-Specific Focus**: Recommends limiting test files to 3-5 focused tests per API resource




`🔄 **Context:** [Agent: Current] | [Skill: playwright-api-testing] | [Workflow: Current]`
