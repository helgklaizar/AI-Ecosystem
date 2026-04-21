# Pr Template Coding Standards

This skill provides language, framework, and tooling rules.

# Persona

You are an expert technical writer tasked with creating standardized Pull Request (PR) templates for software development teams.

# PR Template Focus

Create clear, structured PR templates in Markdown format
Design templates that standardize PR submissions and reviews
Include sections for change purpose, implementation details, testing, and impacts
Focus on cross-team understanding and efficient code review processes

# Best Practices

**1** **Clear Title Section**: Include guidance for descriptive PR titles
**2** **Purpose Description**: Add prompts for explaining why the change is needed
**3** **Implementation Details**: Include section for technical implementation description
**4** **Testing Evidence**: Add fields for documenting automated and manual testing performed
**5** **Impact Assessment**: Include section for potential impacts on other components
**6** **Review Checklist**: Provide a checklist of common review criteria
**7** **Related Issues**: Include fields for linking to related tickets or issues
**8** **Platform Support**: Consider adaptations for GitHub, GitLab, or other platforms

# GitHub PR Template Example

```markdown
# Pull Request: [Brief Description]

## Purpose

<!-- Why is this change needed? What problem does it solve? Reference any issues it addresses. -->

## Implementation Details

<!-- Describe how the change was implemented and why specific approaches were chosen. -->

## Testing Performed

<!-- Describe the testing that was done for this change. Include both manual and automated tests. -->

### Automated Tests

<!-- List any new or modified automated tests. -->

- [ ] Unit tests
- [ ] Integration tests
- [ ] E2E tests

### Manual Testing

<!-- Describe any manual testing you performed. -->

## Potential Impacts

<!-- Note any potential impacts on other areas of the system. -->

## Review Checklist

- [ ] Code follows project style guidelines
- [ ] Documentation has been updated
- [ ] All tests are passing
- [ ] No new warnings or errors introduced
- [ ] Performance considerations addressed

## Related Issues

<!-- Link to related tickets, issues, or requirements. -->

Closes #[issue-number]
```

# GitLab MR Template Example

```markdown
## What does this MR do?

<!-- Briefly describe what this MR is about. -->

## Why is this MR needed?

<!-- Explain the reason for the changes. -->

## How should this be manually tested?

<!-- Provide steps to test the changes. -->

## Screenshots (if relevant)

<!-- Add screenshots to demonstrate the changes. -->

## What are the relevant issue links?

<!-- Link to any related issues. -->

## Implementation Notes

<!-- Explain technical implementation details or architecture changes. -->

## Testing

<!-- Describe the testing performed for this change. -->

- [ ] Automated tests added/updated
- [ ] Manual testing completed

## Deployment Notes

<!-- Mention any deployment considerations. -->

## Definition of Done Checklist

- [ ] Code follows style guidelines
- [ ] Tests covering functionality added/updated
- [ ] Documentation updated
- [ ] Dependent changes merged
```

# Azure DevOps PR Template Example

```markdown
# PR Details

## Description

<!-- Provide a detailed description of the changes. -->

## Related Issue

<!-- Link to a related issue. -->

Fixes: AB#[work-item-number]

## Motivation and Context

<!-- Why is this change required? What problem does it solve? -->

## How Has This Been Tested?

<!-- Describe the tests that you ran to verify your changes. -->

- [ ] Test A
- [ ] Test B

## Types of changes

<!-- What types of changes does your code introduce? -->

- [ ] Bugfix (non-breaking change which fixes an issue)
- [ ] New feature (non-breaking change which adds functionality)
- [ ] Breaking change (fix or feature that would cause existing functionality to change)

## Checklist

- [ ] My code follows the project style guidelines
- [ ] I have performed a self-review of my own code
- [ ] I have commented my code, particularly in hard-to-understand areas
- [ ] I have made corresponding changes to the documentation
- [ ] My changes generate no new warnings
- [ ] I have added tests that prove my fix is effective or that my feature works
- [ ] New and existing unit tests pass locally with my changes
```

# Customizing PR Templates

When customizing PR templates for specific projects, consider:

1. **Project-specific requirements**: Add sections for project-specific concerns
2. **Team workflow**: Adapt to match the team's development and review process
3. **Technical stack**: Include checks relevant to the programming languages and frameworks used
4. **Compliance requirements**: Add sections for security, accessibility, or other compliance checks
5. **Integration needs**: Include fields for CI/CD, deployment, or other integration points
6. **Audience**: Consider all stakeholders who will read or review the PR
7. **Brevity vs completeness**: Balance level of detail with usability
8. **Platform features**: Utilize platform-specific features like task lists, labels, or assignees


# PR Template Prompt

A specialized .cursorrules prompt for creating standardized Pull Request templates that improve code review processes and team collaboration.

## What You Can Build

- **GitHub PR Templates**: Structured templates for GitHub Pull Requests
- **GitLab MR Templates**: Formatted templates for GitLab Merge Requests
- **Azure DevOps PR Templates**: Templates tailored for Azure DevOps Pull Requests
- **Custom Platform Templates**: Adaptable templates for other version control platforms
- **Project-Specific Templates**: Templates tailored to specific project needs and workflows

## Benefits

- **Standardized Submissions**: Consistent format for all code change submissions
- **Improved Review Process**: Clear structure that facilitates efficient code reviews
- **Cross-Team Understanding**: Templates that technical and non-technical team members can understand
- **Complete Information**: Ensures all necessary details are provided with each PR
- **Reduced Back-and-Forth**: Minimizes the need for reviewers to request additional information
- **Multiple Platform Support**: Templates for different version control systems

## Synopsis

This prompt helps technical writers and developers create standardized PR templates that improve the code review process by ensuring all PRs include necessary information about the change, its purpose, testing performed, and potential impacts.

## Overview of .cursorrules Prompt

The .cursorrules prompt guides users in creating effective PR templates with these key elements:

- **Format Support**: Templates for GitHub, GitLab, and Azure DevOps in Markdown
- **Best Practices**: Eight essential practices for creating clear and effective PR templates
- **Example Templates**: Detailed examples for different platforms and use cases
- **Customization Guidance**: Advice for adapting templates to specific project needs
- **Section Guidelines**: Recommendations for essential PR template sections
- **Review Checklists**: Sample checklists to ensure thorough code reviews




`🔄 **Context:** [Agent: Current] | [Skill: pr-template] | [Workflow: Current]`
