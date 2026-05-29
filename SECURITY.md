# Security Policy

## Reporting a Vulnerability

If you discover a security vulnerability in this project, please report it privately by opening an issue with the "Security" label or contacting the maintainer directly. Please do not open a public issue for security vulnerabilities.

## Security Best Practices

This project follows Docker security best practices:

- Images are built with `.dockerignore` to prevent sensitive files from being included in the build context
- Base images use specific version pins to ensure reproducibility
- Containers run as non-root users
- No hardcoded secrets or credentials are used
