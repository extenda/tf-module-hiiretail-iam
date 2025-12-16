# Contributing to HiiRetail IAM Terraform Module

Thank you for your interest in contributing! This document provides guidelines for contributing to this module.

## Getting Started

1. Fork the repository
2. Clone your fork
3. Create a feature branch
4. Make your changes
5. Test your changes
6. Submit a pull request

## Development Setup

### Prerequisites

- Terraform >= 1.0
- Access to HiiRetail test environment
- Git

### Environment Variables

Set up your test environment:

```bash
export HIIRETAIL_CLIENT_ID="test-client-id"
export HIIRETAIL_CLIENT_SECRET="test-client-secret"
export HIIRETAIL_TENANT_ID="test-tenant-id"
```

## Making Changes

### Code Style

- Use 2 spaces for indentation
- Follow [Terraform Style Conventions](https://www.terraform.io/language/syntax/style)
- Run `terraform fmt` before committing
- Use meaningful variable and resource names

### Testing

1. Test your changes with all examples:
   ```bash
   cd examples/simple
   terraform init
   terraform plan
   ```

2. Verify no breaking changes for existing users

3. Test edge cases and error conditions

### Documentation

- Update README.md for any new features
- Update variable descriptions in variables.tf
- Update output descriptions in outputs.tf
- Add examples if introducing new functionality
- Keep CHANGELOG.md updated

## Pull Request Process

1. Update documentation
2. Add or update examples as needed
3. Run `terraform fmt -recursive`
4. Ensure all examples work correctly
5. Update CHANGELOG.md with your changes
6. Submit PR with clear description of changes

### PR Title Format

Use conventional commits format:
- `feat:` New feature
- `fix:` Bug fix
- `docs:` Documentation changes
- `refactor:` Code refactoring
- `test:` Adding tests
- `chore:` Maintenance tasks

Examples:
- `feat: add support for conditional role bindings`
- `fix: correct auto-generation logic for group names`
- `docs: update README with new examples`

## Code Review

All submissions require review. We'll review:
- Code quality and style
- Documentation completeness
- Test coverage
- Backward compatibility
- Security implications

## Reporting Issues

### Bug Reports

Include:
- Terraform version
- Provider version
- Minimal reproduction example
- Expected vs actual behavior
- Error messages

### Feature Requests

Include:
- Use case description
- Proposed implementation approach
- Examples of desired behavior
- Impact on existing functionality

## Security

- Never commit credentials
- Use environment variables for sensitive data
- Report security issues privately to maintainers
- Follow security best practices

## Questions?

Feel free to open an issue for questions or clarifications.

## License

By contributing, you agree that your contributions will be licensed under the MIT License.
