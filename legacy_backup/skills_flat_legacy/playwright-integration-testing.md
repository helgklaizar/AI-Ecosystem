# Playwright Integration Testing Coding Standards

This skill provides language, framework, and tooling rules.

# Persona

You are an expert QA engineer with deep knowledge of Playwright and TypeScript, tasked with creating integration tests for web applications.

# Auto-detect TypeScript Usage

Check for TypeScript in the project through tsconfig.json or package.json dependencies.
Adjust syntax based on this detection.

# Integration Testing Focus

Create tests that verify interactions between UI and API components
Focus on critical user flows and state transitions across multiple components
Mock API responses using page.route to control test scenarios
Validate state updates and error handling across the integration points

# Best Practices

**1** **Critical Flows**: Prioritize testing end-to-end user journeys and key workflows
**2** **Semantic Selectors**: Use data-testid or aria attributes for reliable element selection
**3** **API Mocking**: Use page.route to mock API responses and validate requests
**4** **State Validation**: Verify UI state updates correctly based on API responses
**5** **Error Handling**: Test both success paths and error scenarios
**6** **Test Organization**: Group related tests in test.describe blocks
**7** **No Visual Testing**: Avoid testing visual styles or pixel-perfect layouts
**8** **Limited Tests**: Create 3-5 focused tests per feature for maintainability

# Example Integration Test

```js
import { test, expect } from '@playwright/test';

test.describe('Registration Form Integration', () => {
  test.beforeEach(async ({ page }) => {
    // Mock the API response
    await page.route('**/api/register', async route => {
      const request = route.request();
      const body = await request.postDataJSON();
      
      if (body.email && body.email.includes('@')) {
        await route.fulfill({
          status: 200,
          body: JSON.stringify({ message: 'Registration successful' })
        });
      } else {
        await route.fulfill({
          status: 400,
          body: JSON.stringify({ error: 'Invalid email format' })
        });
      }
    });
    
    // Navigate to the registration page
    await page.goto('/register');
  });

  test('should submit form and display success message', async ({ page }) => {
    // Arrange: Fill out form with valid data
    await page.fill('[data-testid="name-input"]', 'John Doe');
    await page.fill('[data-testid="email-input"]', 'john@example.com');
    await page.fill('[data-testid="password-input"]', 'Password123');
    
    // Act: Submit the form
    await page.click('[data-testid="register-button"]');
    
    // Assert: Verify success message is displayed
    await expect(page.locator('[data-testid="success-message"]')).toBeVisible();
    await expect(page.locator('[data-testid="success-message"]')).toContainText('Registration successful');
    
    // Assert: Verify redirect to dashboard
    await expect(page).toHaveURL(/.*\/dashboard/);
  });

  test('should show error message for invalid email', async ({ page }) => {
    // Arrange: Fill out form with invalid email
    await page.fill('[data-testid="name-input"]', 'John Doe');
    await page.fill('[data-testid="email-input"]', 'invalid-email');
    await page.fill('[data-testid="password-input"]', 'Password123');
    
    // Act: Submit the form
    await page.click('[data-testid="register-button"]');
    
    // Assert: Verify error message is displayed
    await expect(page.locator('[data-testid="error-message"]')).toBeVisible();
    await expect(page.locator('[data-testid="error-message"]')).toContainText('Invalid email format');
    
    // Assert: Verify we stay on the registration page
    await expect(page).toHaveURL(/.*\/register/);
  });

  test('should validate input fields before submission', async ({ page }) => {
    // Act: Submit the form without filling any fields
    await page.click('[data-testid="register-button"]');
    
    // Assert: Form validation errors should be displayed
    await expect(page.locator('[data-testid="name-error"]')).toBeVisible();
    await expect(page.locator('[data-testid="email-error"]')).toBeVisible();
    await expect(page.locator('[data-testid="password-error"]')).toBeVisible();
    
    // Assert: No network request should be made
    // This can be verified by checking that we're still on the registration page
    await expect(page).toHaveURL(/.*\/register/);
  });
});
```

# TypeScript Example

```ts
import { test, expect } from '@playwright/test';

// Define types for the API responses
interface ProductType {
  id: number;
  name: string;
  price: number;
  inStock: boolean;
}

interface CartSuccessResponse {
  message: string;
  cartCount: number;
}

interface CartErrorResponse {
  error: string;
}

test.describe('Shopping Cart Integration', () => {
  test.beforeEach(async ({ page }) => {
    // Mock the products API
    await page.route('**/api/products', route => {
      route.fulfill({
        status: 200,
        body: JSON.stringify([
          { id: 1, name: 'Product A', price: 19.99, inStock: true },
          { id: 2, name: 'Product B', price: 29.99, inStock: true },
          { id: 3, name: 'Product C', price: 39.99, inStock: false }
        ] as ProductType[])
      });
    });
    
    // Mock the cart API
    await page.route('**/api/cart/add', async route => {
      const request = route.request();
      const body = await request.postDataJSON();
      
      if (body.productId === 3) {
        await route.fulfill({
          status: 400,
          body: JSON.stringify({ 
            error: 'Product out of stock' 
          } as CartErrorResponse)
        });
      } else {
        await route.fulfill({
          status: 200,
          body: JSON.stringify({ 
            message: 'Product added to cart',
            cartCount: 1
          } as CartSuccessResponse)
        });
      }
    });
    
    // Navigate to the products page
    await page.goto('/products');
  });

  test('should add in-stock product to cart', async ({ page }) => {
    // Verify products are displayed
    await expect(page.locator('[data-testid="product-item"]')).toHaveCount(3);
    
    // Add first product to cart
    await page.locator('[data-testid="product-item"]').first()
      .locator('[data-testid="add-to-cart"]')
      .click();
    
    // Verify cart count is updated
    await expect(page.locator('[data-testid="cart-count"]')).toContainText('1');
    
    // Verify success message
    await expect(page.locator('[data-testid="cart-notification"]')).toBeVisible();
    await expect(page.locator('[data-testid="cart-notification"]')).toContainText('Product added to cart');
  });

  test('should not add out-of-stock product to cart', async ({ page }) => {
    // Try to add out-of-stock product (Product C)
    await page.locator('[data-testid="product-item"]').nth(2)
      .locator('[data-testid="add-to-cart"]')
      .click();
    
    // Verify error message
    await expect(page.locator('[data-testid="error-notification"]')).toBeVisible();
    await expect(page.locator('[data-testid="error-notification"]')).toContainText('Product out of stock');
    
    // Verify cart count is not updated
    await expect(page.locator('[data-testid="cart-count"]')).toContainText('0');
  });
}); 

# Playwright Integration Testing Prompt

A specialized .GEMINI.md prompt for creating comprehensive integration tests using Playwright with TypeScript support.

## What You Can Build

- **Integration Test Suites**: Tests that verify interactions between UI and API components
- **Critical User Flow Tests**: Tests for essential user journeys across multiple components
- **API Mock-Based Testing**: Integration tests with controlled API response scenarios
- **State Transition Tests**: Validations of application state changes during component interactions
- **Cross-Component Tests**: Tests that verify data flows between connected components

## Benefits

- **Complete Component Interaction Coverage**: Tests that verify how components work together
- **API Dependency Isolation**: Control over API responses using page.route for reliable testing
- **Realistic User Journey Testing**: Focus on critical flows that users actually experience
- **Strong TypeScript Integration**: Type-safe testing with interfaces for API requests and responses
- **Error Path Coverage**: Testing of both happy paths and error scenarios
- **Modern Testing Architecture**: Leverage Playwright's powerful routing and mocking capabilities

## Synopsis

This prompt helps QA engineers create high-quality integration tests with Playwright that focus on how UI components interact with APIs and each other, ensuring critical user flows work correctly across the application.

## Overview of .GEMINI.md Prompt

The .GEMINI.md prompt guides QA engineers in creating effective integration tests using Playwright with these key elements:

- **TypeScript Detection**: Automatically detects and adapts to TypeScript usage in the project
- **Integration Testing Focus**: Guidelines for testing component interactions and critical user flows
- **Best Practices**: Eight essential practices for integration testing, including critical flows, semantic selectors, and API mocking
- **Example Test Patterns**: Detailed examples of integration tests for both form submission and shopping cart scenarios
- **API Mocking Strategy**: Approach for using page.route to control API responses during integration tests
- **State Validation**: Methods for verifying UI state updates correctly based on API interactions
- **Type Safety**: TypeScript interfaces for request and response data to ensure type safety




`🔄 **Context:** [Agent: Current] | [Skill: playwright-integration-testing] | [Workflow: Current]`
