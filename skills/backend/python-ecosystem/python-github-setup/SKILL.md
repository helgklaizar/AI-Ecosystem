# Python Github Setup Coding Standards

This skill provides language, framework, and tooling rules.

{"general": {"coding_style": {"language": "Python","use_strict": true,"indentation": "4 spaces","max_line_length": 120,"comments": {"style": "# for single-line, ''' for multi-line","require_comments": true}},"naming_conventions": {"variables": "snake_case","functions": "snake_case","classes": "PascalCase","interfaces": "PascalCase","files": "snake_case"},"error_handling": {"prefer_try_catch": true,"log_errors": true},"testing": {"require_tests": true,"test_coverage": "80%","test_types": ["unit", "integration"]},"documentation": {"require_docs": true,"doc_tool": "docstrings","style_guide": "Google Python Style Guide"},"security": {"require_https": true,"sanitize_inputs": true,"validate_inputs": true,"use_env_vars": true},"configuration_management": {"config_files": [".env"],"env_management": "python-dotenv","secrets_management": "environment variables"},"code_review": {"require_reviews": true,"review_tool": "GitHub Pull Requests","review_criteria": ["functionality", "code quality", "security"]},"version_control": {"system": "Git","branching_strategy": "GitHub Flow","commit_message_format": "Conventional Commits"},"logging": {  "logging_tool": "Python logging module",  "log_levels": ["debug", "info", "warn", "error"],  "log_retention_policy": "7 days"  },  "monitoring": {  "monitoring_tool": "Not specified",  "metrics": ["file processing time", "classification accuracy", "error rate"]  },  "dependency_management": {  "package_manager": "pip",  "versioning_strategy": "Semantic Versioning"  },  "accessibility": {  "standards": ["Not applicable"],  "testing_tools": ["Not applicable"]  },  "internationalization": {  "i18n_tool": "Not applicable",  "supported_languages": ["English"],  "default_language": "English"  },  "ci_cd": {  "ci_tool": "GitHub Actions",  "cd_tool": "Not specified",  "pipeline_configuration": ".github/workflows/main.yml"  },  "code_formatting": {  "formatter": "Black",  "linting_tool": "Pylint",  "rules": ["PEP 8", "project-specific rules"]  },  "architecture": {    "patterns": ["Modular design"],    "principles": ["Single Responsibility", "DRY"]    }    },    "project_specific": {    "use_framework": "None",    "styling": "Not applicable",    "testing_framework": "pytest",    "build_tool": "setuptools",    "deployment": {    "environment": "Local machine",    "automation": "Not specified",    "strategy": "Manual deployment"    },    "performance": {    "benchmarking_tool": "Not specified",    "performance_goals": {    "response_time": "< 5 seconds per file",    "throughput": "Not specified",    "error_rate": "< 1%"    }    }    },    "context": {      "codebase_overview": "Python-based file organization tool using AI for content analysis and classification",      "libraries": ["watchdog", "spacy", "PyPDF2", "python-docx", "pandas", "beautifulsoup4", "transformers", "scikit-learn", "joblib", "python-dotenv", "torch", "pytest", "shutil", "logging", "pytest-mock"],      "coding_practices": {      "modularity": true,      "DRY_principle": true,      "performance_optimization": true      }      },      "behavior": {      "verbosity": {      "level": 2,      "range": [0, 3]      },      "handle_incomplete_tasks": "Provide partial solution and explain limitations",      "ask_for_clarification": true,      "communication_tone": "Professional and concise"      }      }

# Python GitHub Setup .GEMINI.md prompt file

Author: Jesse Naldo

## What you can build
AI File Sorting Plugin for IDEs:Interactive AI File Organizing Dashboard:Intelligent File Organization Chatbot:Open Source File Classification Extension:AI-Powered Data Import Tool:

## Benefits


## Synopsis
Developers building Python-based AI file organization tools would benefit from this prompt to ensure code quality, security, and consistency.

## Overview of .GEMINI.md prompt
The .GEMINI.md file provides a comprehensive configuration for a Python-based project. It outlines the coding style, naming conventions, and error handling practices to ensure code quality and consistency. The file specifies that the code should be well-commented, tested, and documented according to the Google Python Style Guide. Emphasis is placed on security, configuration management, and version control, recommending Git with GitHub Flow branching strategy. It also includes guidelines for logging, monitoring, dependency management, and accessibility, with CI/CD set up via GitHub Actions. The architecture promotes modular design and principles like DRY and Single Responsibility. Project-specific settings like testing with pytest and manual deployment strategies are included. This file aims to provide a coherent structure and best practices for developing a Python-based AI tool for file organization and content analysis.





`🔄 **Context:** [Agent: Current] | [Skill: python-github-setup] | [Workflow: Current]`
