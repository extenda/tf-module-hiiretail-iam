# 📚 Documentation Index

Welcome to the HiiRetail IAM Terraform Module documentation. This index helps you find the information you need quickly.

## 🚀 Getting Started (Start Here!)

1. **[QUICKSTART.md](QUICKSTART.md)** - Get up and running in 5 minutes
   - Prerequisites
   - Basic setup
   - Your first deployment

2. **[README.md](README.md)** - Main module documentation
   - Complete feature overview
   - Detailed usage instructions
   - Input/output reference

## 📖 Core Documentation

### For Users

- **[README.md](README.md)** - Complete module documentation
  - Features and capabilities
  - Usage patterns
  - Configuration reference
  - Best practices

- **[QUICKSTART.md](QUICKSTART.md)** - Quick start guide
  - 5-minute setup
  - Common tasks
  - Troubleshooting

- **[examples/](examples/)** - Working examples
  - [Complete Example](examples/complete/) - YAML-driven (recommended)
  - [Simple Example](examples/simple/) - Basic inline config
  - [Manual Example](examples/manual/) - Full control
  - [Examples Overview](examples/README.md)

### For Architects

- **[ARCHITECTURE.md](ARCHITECTURE.md)** - Architecture diagrams and design
  - Module architecture
  - Resource relationships
  - Auto-generation logic
  - Data flow diagrams
  - Scale examples

- **[MODULE_SUMMARY.md](MODULE_SUMMARY.md)** - Project overview
  - What was created
  - Key features
  - Design decisions
  - Scaling guidance

### For Contributors

- **[CONTRIBUTING.md](CONTRIBUTING.md)** - How to contribute
  - Development setup
  - Code standards
  - Testing requirements
  - PR process

- **[CHANGELOG.md](CHANGELOG.md)** - Version history
  - What changed and when
  - Breaking changes
  - New features

## 🔧 Module Files

### Configuration Files

| File | Purpose | When to Edit |
|------|---------|--------------|
| [versions.tf](versions.tf) | Provider requirements | Almost never |
| [variables.tf](variables.tf) | Input definitions | When forking/extending |
| [main.tf](main.tf) | Core logic | When forking/extending |
| [outputs.tf](outputs.tf) | Output definitions | When forking/extending |

### Support Files

| File | Purpose |
|------|---------|
| [Makefile](Makefile) | Development automation |
| [.gitignore](.gitignore) | Git ignore patterns |
| [LICENSE](LICENSE) | MIT License |

## 📋 Reference Documentation

### Quick Reference Tables

#### Input Variables

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `custom_roles` | map(object) | `{}` | Custom roles to create |
| `business_units` | map(object) | `{}` | Business units (stores) |
| `groups` | map(object) | `{}` | Manual groups |
| `role_bindings` | list(object) | `[]` | Manual role bindings |
| `auto_generate_groups` | bool | `true` | Enable auto group generation |
| `auto_generate_role_bindings` | bool | `true` | Enable auto binding generation |

Full details in [variables.tf](variables.tf)

#### Outputs

| Output | Description |
|--------|-------------|
| `custom_roles` | Created custom roles with details |
| `business_units` | Created business unit resources |
| `groups` | All groups (manual + auto) |
| `role_bindings` | All role bindings |
| `auto_generated_groups_map` | Relationship mapping |

Full details in [outputs.tf](outputs.tf)

### HiiRetail Resources Managed

| Resource | Terraform Type | Purpose |
|----------|---------------|---------|
| Custom Role | `hiiretail_iam_custom_role` | Define permissions |
| Business Unit | `hiiretail_iam_resource` | Represent stores |
| Group | `hiiretail_iam_group` | Collect users |
| Role Binding | `hiiretail_iam_role_binding` | Grant access |

## 🎯 Documentation by Use Case

### I want to...

#### Get started quickly
→ [QUICKSTART.md](QUICKSTART.md)

#### Understand the architecture
→ [ARCHITECTURE.md](ARCHITECTURE.md)

#### See working examples
→ [examples/README.md](examples/README.md)

#### Deploy for production
→ [examples/complete/](examples/complete/)

#### Customize the module
→ [README.md](README.md) → "Usage" section

#### Understand design decisions
→ [MODULE_SUMMARY.md](MODULE_SUMMARY.md) → "Design Decisions"

#### Contribute to the project
→ [CONTRIBUTING.md](CONTRIBUTING.md)

#### Troubleshoot issues
→ [QUICKSTART.md](QUICKSTART.md) → "Troubleshooting"

#### Scale to many stores
→ [README.md](README.md) → "How It Works" → "Automatic Group Generation"

#### Manage manually
→ [examples/manual/](examples/manual/)

#### Integrate with CI/CD
→ [ARCHITECTURE.md](ARCHITECTURE.md) → "CI/CD Integration"

## 📚 Learning Path

### Beginner
1. Read [QUICKSTART.md](QUICKSTART.md)
2. Try [examples/simple/](examples/simple/)
3. Review [README.md](README.md) basics

### Intermediate
1. Study [examples/complete/](examples/complete/)
2. Understand [ARCHITECTURE.md](ARCHITECTURE.md)
3. Review [MODULE_SUMMARY.md](MODULE_SUMMARY.md)

### Advanced
1. Explore [examples/manual/](examples/manual/)
2. Read [main.tf](main.tf) implementation
3. Review [CONTRIBUTING.md](CONTRIBUTING.md)

## 🔗 External Resources

- [HiiRetail Provider Documentation](https://registry.terraform.io/providers/extenda/hiiretail/latest/docs)
- [HiiRetail Provider Authentication](https://registry.terraform.io/providers/extenda/hiiretail/latest/docs/guides/authentication)
- [Terraform Documentation](https://www.terraform.io/docs)
- [Terraform Best Practices](https://www.terraform.io/docs/cloud/guides/recommended-practices/index.html)

## 📞 Getting Help

### Documentation
- Check this index for the right document
- Search within documentation files
- Review examples for patterns

### Issues
- Check [QUICKSTART.md](QUICKSTART.md) troubleshooting
- Review existing GitHub issues
- Create a new issue with details

### Contributing
- Read [CONTRIBUTING.md](CONTRIBUTING.md)
- Check [CHANGELOG.md](CHANGELOG.md) for recent changes
- Follow the PR process

## 🗺️ File Structure Overview

```
tf-module-hii-iam/
│
├── 📖 Documentation
│   ├── README.md              ← Start here for features
│   ├── QUICKSTART.md          ← Start here for quick setup
│   ├── ARCHITECTURE.md        ← Architecture & design
│   ├── MODULE_SUMMARY.md      ← Project overview
│   ├── INDEX.md               ← This file
│   ├── CHECKLIST.md           ← Completion status
│   ├── CONTRIBUTING.md        ← How to contribute
│   ├── CHANGELOG.md           ← Version history
│   └── LICENSE                ← MIT License
│
├── 🔧 Module Core
│   ├── versions.tf            ← Version requirements
│   ├── variables.tf           ← Input definitions
│   ├── main.tf                ← Core logic
│   └── outputs.tf             ← Output definitions
│
├── 📝 Examples
│   ├── README.md              ← Examples overview
│   ├── complete/              ← YAML-driven (recommended)
│   ├── simple/                ← Basic example
│   └── manual/                ← Manual control
│
└── 🛠️ Tools
    ├── Makefile               ← Automation tasks
    └── .gitignore             ← Git configuration
```

## 🎯 Quick Commands

```bash
# Format code
make fmt

# Validate module
make validate

# Test all examples
make test-all

# Plan complete example
make plan-complete

# Clean up
make clean

# Check environment
make check-env

# Help
make help
```

## 📊 Statistics

- **Total Files**: 27+
- **Documentation Pages**: 8
- **Examples**: 3 complete examples
- **Resources Managed**: 4 types
- **Lines of Documentation**: 2000+
- **Lines of Code**: 500+

## 🔄 Update Frequency

- **CHANGELOG.md**: Updated with each release
- **README.md**: Updated with new features
- **Examples**: Updated with new patterns
- **Other docs**: Updated as needed

## 📝 Notes

- All paths are relative to module root
- Examples are self-contained and can be copied
- Documentation follows markdown best practices
- Code follows Terraform style guide

---

**Last Updated**: December 16, 2025  
**Module Version**: 1.0.0  
**Maintained By**: Extenda Retail

For questions or issues, please refer to the appropriate documentation section or create an issue.
