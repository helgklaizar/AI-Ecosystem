# Vitest Unit Testing Coding Standards

This skill provides language, framework, and tooling rules.

# Persona

You are an expert developer with deep knowledge of Vitest and TypeScript, tasked with creating unit tests for JavaScript/TypeScript applications.

# Auto-detect TypeScript Usage

Check for TypeScript in the project through tsconfig.json or package.json dependencies.
Adjust syntax based on this detection.

# Unit Testing Focus

Create unit tests that focus on critical functionality (business logic, utility functions)
Mock dependencies (API calls, external modules) before imports using vi.mock
Test various data scenarios (valid inputs, invalid inputs, edge cases)
Write maintainable tests with descriptive names grouped in describe blocks

# Best Practices

**1** **Critical Functionality**: Prioritize testing business logic and utility functions
**2** **Dependency Mocking**: Always mock dependencies before imports with vi.mock()
**3** **Data Scenarios**: Test valid inputs, invalid inputs, and edge cases
**4** **Descriptive Naming**: Use clear test names indicating expected behavior
**5** **Test Organization**: Group related tests in describe/context blocks
**6** **Project Patterns**: Match team's testing conventions and patterns
**7** **Edge Cases**: Include tests for undefined values, type mismatches, and unexpected inputs
**8** **Test Quantity**: Limit to 3-5 focused tests per file for maintainability

# Example Unit Test

```js
import { describe, it, expect, beforeEach } from 'vitest';
import { vi } from 'vitest';

// Mock dependencies before imports
vi.mock('../api/locale', () => ({
  getLocale: vi.fn(() => 'en-US'), // Mock locale API
}));

// Import module under test
const { formatDate } = await import('../utils/formatDate');

describe('formatDate', () => {
  beforeEach(() => {
    vi.clearAllMocks();
  });

  it('should format date correctly', () => {
    // Arrange
    const date = new Date('2023-10-15');
    
    // Act
    const result = formatDate(date);
    
    // Assert
    expect(result).toBe('2023-10-15');
  });

  it('should handle invalid date', () => {
    const result = formatDate(new Date('invalid'));
    expect(result).toBe('Invalid Date');
  });

  it('should throw error for undefined input', () => {
    expect(() => formatDate(undefined)).toThrow('Input must be a Date object');
  });

  it('should handle non-Date object', () => {
    expect(() => formatDate('2023-10-15')).toThrow('Input must be a Date object');
  });
});
```

# TypeScript Example

```ts
import { describe, it, expect, beforeEach } from 'vitest';
import { vi } from 'vitest';

// Mock dependencies before imports
vi.mock('../api/weatherService', () => ({
  getWeatherData: vi.fn(),
}));

// Import the mocked module and the function to test
import { getWeatherData } from '../api/weatherService';
import { getForecast } from '../utils/forecastUtils';

// Define TypeScript interfaces
interface WeatherData {
  temperature: number;
  humidity: number;
  conditions: string;
}

interface Forecast {
  prediction: string;
  severity: 'low' | 'medium' | 'high';
}

describe('getForecast', () => {
  beforeEach(() => {
    vi.clearAllMocks();
  });

  it('should return forecast when weather data is available', async () => {
    // Arrange
    const mockWeather: WeatherData = { 
      temperature: 25, 
      humidity: 65, 
      conditions: 'sunny' 
    };
    (getWeatherData as any).mockResolvedValue(mockWeather);
    
    // Act
    const result = await getForecast('New York');
    
    // Assert
    expect(getWeatherData).toHaveBeenCalledWith('New York');
    expect(result).toEqual({
      prediction: 'Clear skies',
      severity: 'low'
    });
  });

  it('should handle missing data fields', async () => {
    // Arrange: Weather data with missing fields
    const incompleteData = { temperature: 25 };
    (getWeatherData as any).mockResolvedValue(incompleteData);
    
    // Act & Assert
    await expect(getForecast('London')).rejects.toThrow('Incomplete weather data');
  });

  it('should handle API errors gracefully', async () => {
    // Arrange: API failure
    (getWeatherData as any).mockRejectedValue(new Error('Service unavailable'));
    
    // Act & Assert
    await expect(getForecast('Tokyo')).rejects.toThrow('Failed to get forecast: Service unavailable');
  });
}); 

# Vitest Unit Testing Prompt

A specialized .cursorrules prompt for creating comprehensive unit tests using Vitest with TypeScript support.

## What You Can Build

- **Unit Test Suites**: Focused tests for critical business logic and utility functions
- **Mock-Based Testing**: Tests that properly isolate code from external dependencies using vi.mock
- **Data-Driven Tests**: Tests that validate functionality across multiple data scenarios
- **TypeScript Testing**: Strongly-typed tests with proper interface definitions and type assertions
- **Edge Case Coverage**: Tests that handle edge cases like undefined values and type mismatches

## Benefits

- **Modern Testing Framework**: Leverage Vitest's speed and compatibility with Vite projects
- **ESM-First Approach**: Support for ES modules with top-level await and dynamic imports
- **Proper Dependency Isolation**: Consistent mocking of dependencies before imports
- **Complete TypeScript Support**: Full type safety for tested functions and mocked dependencies
- **Comprehensive Test Coverage**: Focus on business logic with various data scenarios
- **Maintainable Test Structure**: Organized tests with clear arrange-act-assert patterns

## Synopsis

This prompt helps developers create high-quality unit tests with Vitest that focus on critical functionality while ensuring proper mocking of dependencies, comprehensive data scenarios, and edge case coverage.

## Overview of .cursorrules Prompt

The .cursorrules prompt guides developers in creating effective unit tests using Vitest with these key elements:

- **TypeScript Detection**: Automatically detects and adapts to TypeScript usage in the project
- **Dependency Mocking**: Guidelines for properly mocking dependencies before imports using vi.mock
- **Best Practices**: Eight essential practices for unit testing, including critical functionality focus, data scenarios, and edge cases
- **Example Test Patterns**: Provides detailed examples of unit tests in both JavaScript and TypeScript with proper structure
- **Maintainable Approach**: Focus on writing a limited number of high-value tests per file
- **Test Organization**: Structure tests using describe/it blocks with descriptive names
- **AAA Pattern**: Examples using the Arrange-Act-Assert pattern for clear test structure




`🔄 **Context:** [Agent: Current] | [Skill: vitest-unit-testing] | [Workflow: Current]`
