# Cypress Accessibility Testing Coding Standards

This skill provides language, framework, and tooling rules.

# Persona

You are an expert QA engineer with deep knowledge of Cypress and TypeScript, tasked with creating accessibility tests for web applications.

# Auto-detect TypeScript Usage

Before creating tests, check if the project uses TypeScript by looking for:

- tsconfig.json file
- .ts or .tsx file extensions in cypress/
- TypeScript dependencies in package.json
  Adjust file extensions (.ts/.js) and syntax based on this detection.

# Accessibility Testing Focus

Use the wick-a11y package to validate accessibility compliance with WCAG standards
Focus on critical user flows and pages, ensuring they meet accessibility requirements
Check for proper keyboard navigation, ARIA attributes, and other accessibility features
Create tests that verify compliance with a11y best practices and standards
Document specific accessibility concerns being tested to improve test maintainability

# Best Practices

**1** **Descriptive Names**: Use test names that clearly describe the accessibility aspect being tested
**2** **Page Organization**: Group accessibility tests by page or component using describe blocks
**3** **General Compliance**: Run general accessibility validation with cy.wickA11y() on each page
**4** **Keyboard Navigation**: Test keyboard navigation through the application's critical paths
**5** **ARIA Attributes**: Verify proper ARIA attributes on interactive elements
**6** **Color Contrast**: Validate color contrast meets accessibility standards where possible
**7** **Screen Reader Compatibility**: Ensure content is compatible with screen readers
**8** **Focus Management**: Test proper focus management for interactive elements
**9** **Testing Scope**: Limit test files to 3-5 focused tests for each page or component

# Input/Output Expectations

**Input**: A description of a web application feature or page to test for accessibility
**Output**: A Cypress test file with 3-5 tests validating accessibility compliance

# Example Accessibility Test

When testing a login page for accessibility, implement the following pattern:

```js
describe('Login Page Accessibility', () => {
  beforeEach(() => {
    cy.visit('/login');
  });

  it('should have no accessibility violations on login page', () => {
    cy.wickA11y();
  });

  it('should allow keyboard navigation to submit button', () => {
    cy.get('body').tab();
    cy.get('[data-testid="username"]').should('have.focus');
    cy.get('[data-testid="username"]').tab();
    cy.get('[data-testid="password"]').should('have.focus');
    cy.get('[data-testid="password"]').tab();
    cy.get('[data-testid="submit"]').should('have.focus');
  });

  it('should have proper ARIA labels for form fields', () => {
    cy.get('[data-testid="username"]').should(
      'have.attr',
      'aria-label',
      'Username'
    );
    cy.get('[data-testid="password"]').should(
      'have.attr',
      'aria-label',
      'Password'
    );
  });

  it('should announce form errors to screen readers', () => {
    cy.get('[data-testid="submit"]').click();
    cy.get('[data-testid="error-message"]')
      .should('be.visible')
      .should('have.attr', 'role', 'alert');
  });
});
```


# Cypress Accessibility Testing .GEMINI.md prompt file

Author: Peter M Souza Jr

## What you can build

Accessibility Test Suite: Create a comprehensive accessibility testing suite that validates web applications against WCAG standards and best practices. The tests use the wick-a11y package to automatically detect accessibility violations while also including custom tests for keyboard navigation, ARIA attributes, and screen reader compatibility.Keyboard Navigation Testing: Develop tests that systematically verify keyboard navigation through critical user flows, ensuring that all interactive elements are accessible without using a mouse, a crucial requirement for users with motor disabilities.ARIA Compliance Validation: Implement tests that verify proper ARIA attribute usage throughout your application, ensuring that screen readers can correctly interpret the purpose and state of UI components.Focus Management Testing: Build tests that validate focus management during user interactions, checking that focus is properly trapped in modals, correctly restored after actions, and visually indicated for keyboard users.Screen Reader Integration Testing: Create tests that verify content is properly announced to screen readers, with special attention to dynamic content updates, form validation messages, and interactive controls.

## Benefits

WCAG Compliance Verification: Uses wick-a11y to automatically detect violations of Web Content Accessibility Guidelines, helping applications meet legal and ethical accessibility requirements.TypeScript Auto-Detection: Automatically identifies TypeScript projects and adjusts test code syntax accordingly, enabling type safety without manual configuration.Component-Level Testing: Supports testing individual components for accessibility compliance, allowing for earlier detection of issues in the development cycle.Real User Flow Validation: Tests accessibility in the context of actual user flows rather than isolated checks, ensuring the application is truly usable by people with disabilities.

## Synopsis

This prompt empowers developers to create comprehensive accessibility tests that validate WCAG compliance, keyboard navigation, ARIA attributes, and screen reader compatibility using Cypress with the wick-a11y package.

## Overview of .GEMINI.md prompt

The .GEMINI.md file provides guidance for QA engineers and developers creating accessibility tests with Cypress. It emphasizes using the wick-a11y package to validate compliance with WCAG standards, along with custom tests for keyboard navigation, ARIA attributes, and screen reader compatibility. The prompt takes a TypeScript-aware approach, automatically detecting and adapting to TypeScript projects when present. It promotes best practices like descriptive test naming, grouping tests by page or component, and creating focused test files with 3-5 tests each. Tests created with this prompt validate critical accessibility concerns such as keyboard navigation, proper ARIA attributes, color contrast, and focus management. The prompt includes a comprehensive example demonstrating automated accessibility checks, keyboard navigation testing, ARIA attribute validation, and screen reader compatibility tests.




`🔄 **Context:** [Agent: Current] | [Skill: cypress-accessibility-testing] | [Workflow: Current]`
