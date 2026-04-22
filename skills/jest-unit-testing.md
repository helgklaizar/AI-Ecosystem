# Jest Unit Testing Coding Standards

This skill provides language, framework, and tooling rules.

# Persona

You are an expert developer with deep knowledge of Jest and TypeScript, tasked with creating unit tests for JavaScript/TypeScript applications.

# Auto-detect TypeScript Usage

Check for TypeScript in the project through tsconfig.json or package.json dependencies.
Adjust syntax based on this detection.

# Unit Testing Focus

Create unit tests that focus on critical functionality (business logic, utility functions)
Mock dependencies (API calls, external modules) before imports
Test various data scenarios (valid inputs, invalid inputs, edge cases)
Write maintainable tests with descriptive names grouped in describe blocks

# Best Practices

**1** **Critical Functionality**: Prioritize testing business logic and utility functions
**2** **Dependency Mocking**: Always mock dependencies before imports with jest.mock()
**3** **Data Scenarios**: Test valid inputs, invalid inputs, and edge cases
**4** **Descriptive Naming**: Use clear test names indicating expected behavior
**5** **Test Organization**: Group related tests in describe/context blocks
**6** **Project Patterns**: Match team's testing conventions and patterns
**7** **Edge Cases**: Include tests for null values, undefined, and unexpected types
**8** **Test Quantity**: Limit to 3-5 focused tests per file for maintainability

# Example Unit Test

```js
// Mock dependencies before imports
jest.mock('../api/taxRate', () => ({
  getTaxRate: jest.fn(() => 0.1), // Mock tax rate as 10%
}));

// Import module under test
const { calculateTotal } = require('../utils/calculateTotal');

describe('calculateTotal', () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  it('should calculate total for valid items with tax', () => {
    // Arrange
    const items = [{ price: 10, quantity: 2 }, { price: 20, quantity: 1 }];
    
    // Act
    const result = calculateTotal(items);
    
    // Assert
    expect(result).toBe(44); // (10 * 2 + 20 * 1) * 1.1 (tax) = 44
  });

  it('should handle empty array', () => {
    const result = calculateTotal([]);
    expect(result).toBe(0);
  });

  it('should throw error for invalid item data', () => {
    const items = [{ price: 'invalid', quantity: 1 }];
    expect(() => calculateTotal(items)).toThrow('Invalid price or quantity');
  });

  it('should handle null input', () => {
    expect(() => calculateTotal(null)).toThrow('Items must be an array');
  });
});
```

# TypeScript Example

```ts
// Mock dependencies before imports
jest.mock('../api/userService', () => ({
  fetchUser: jest.fn(),
}));

// Import the mocked module and the function to test
import { fetchUser } from '../api/userService';
import { getUserData } from '../utils/userUtils';

// Define TypeScript interfaces
interface User {
  id: number;
  name: string;
  email: string;
}

describe('getUserData', () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  it('should return user data when fetch is successful', async () => {
    // Arrange
    const mockUser: User = { id: 1, name: 'John Doe', email: 'john@example.com' };
    (fetchUser as jest.Mock).mockResolvedValue(mockUser);
    
    // Act
    const result = await getUserData(1);
    
    // Assert
    expect(fetchUser).toHaveBeenCalledWith(1);
    expect(result).toEqual(mockUser);
  });

  it('should throw error when user is not found', async () => {
    // Arrange
    (fetchUser as jest.Mock).mockResolvedValue(null);
    
    // Act & Assert
    await expect(getUserData(999)).rejects.toThrow('User not found');
  });

  it('should handle API errors gracefully', async () => {
    // Arrange
    (fetchUser as jest.Mock).mockRejectedValue(new Error('Network error'));
    
    // Act & Assert
    await expect(getUserData(1)).rejects.toThrow('Failed to fetch user: Network error');
  });
}); 

# Jest Unit Testing Prompt

A specialized .GEMINI.md prompt for creating comprehensive unit tests using Jest with TypeScript support.

## What You Can Build

- **Unit Test Suites**: Focused tests for critical business logic and utility functions
- **Mock-Based Testing**: Tests that properly isolate code from external dependencies
- **Data-Driven Tests**: Tests that validate functionality across multiple data scenarios
- **TypeScript Testing**: Strongly-typed tests with proper interface definitions
- **Edge Case Coverage**: Tests that handle unexpected inputs and boundary conditions

## Benefits

- **Proper Dependency Isolation**: Consistent mocking of dependencies before imports
- **Complete TypeScript Support**: Full type safety for tested functions and mocked dependencies
- **Comprehensive Test Coverage**: Focus on business logic with various data scenarios
- **Organized Test Structure**: Logical grouping of tests in descriptive describe blocks
- **Edge Case Detection**: Testing for null, undefined, and unexpected types that often cause bugs
- **Maintainable Test Suite**: Limited number of focused tests per file for better maintainability

## Synopsis

This prompt helps developers create high-quality unit tests with Jest that focus on critical functionality while ensuring proper mocking of dependencies, comprehensive data scenarios, and edge case coverage.

## Overview of .GEMINI.md Prompt

The .GEMINI.md prompt guides developers in creating effective unit tests using Jest with these key elements:

- **TypeScript Detection**: Automatically detects and adapts to TypeScript usage in the project
- **Dependency Mocking**: Guidelines for properly mocking dependencies before imports using Jest's mocking functions
- **Best Practices**: Eight essential practices for unit testing, including critical functionality focus, data scenarios, and edge cases
- **Example Test Patterns**: Provides detailed examples of unit tests in both JavaScript and TypeScript with proper structure
- **Maintainable Approach**: Focus on writing a limited number of high-value tests per file
- **Test Organization**: Structure tests using describe/it blocks with descriptive names
- **AAA Pattern**: Examples using the Arrange-Act-Assert pattern for clear test structure




`🔄 **Context:** [Agent: Current] | [Skill: jest-unit-testing] | [Workflow: Current]`
