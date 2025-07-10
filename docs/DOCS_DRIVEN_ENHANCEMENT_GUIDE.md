# ForkCast Documentation-Driven Workspace Enhancement Guide

## Overview

The enhanced `setup-dual-environments.bat` script now supports automated creation of feature-specific workspaces based on documentation files in any `docs/sandbox/[feature-name]/` directory structure. This extends the current template-based workspace creation to support documentation-driven development workflows for any application feature.

## New Documentation-Driven Mode

### Core Concept

Documentation-driven workspace creation automatically discovers methodology files in structured documentation directories and creates dedicated workspaces for each development approach. This enables teams to explore different implementation strategies for any feature with isolated development environments.

### Directory Structure Requirements

```
docs/sandbox/[feature-name]/
├── 00-*-foundation.md          # Foundation document (required)
├── 01-*-methodology.md         # First methodology (creates workspace)
├── 02-*-methodology.md         # Second methodology (creates workspace)
├── 03-*-methodology.md         # Third methodology (creates workspace)
└── ...                         # Additional methodologies
```

### Example: Design System Feature

```
docs/sandbox/design-system/
├── 00-design-system-foundation.md
├── 01-design-tokens-first-methodology.md
├── 02-feature-driven-methodology.md
└── 03-component-library-methodology.md
```

**Generated Workspaces:**
- `ForkCast-design-tokens-first-v1`
- `ForkCast-feature-driven-v1`
- `ForkCast-component-library-v1`

## Enhanced Command-Line Interface

### New Usage Patterns

```cmd
# Documentation-driven mode
setup-dual-environments.bat [number] docs-driven [feature-name]

# Examples
setup-dual-environments.bat 1 docs-driven design-system
setup-dual-environments.bat 2 docs-driven authentication
setup-dual-environments.bat 1 docs-driven payment-processing
```

### Backward Compatibility

All existing usage patterns continue to work unchanged:

```cmd
# Standard workspaces
setup-dual-environments.bat                    # ForkCast-v1
setup-dual-environments.bat 2                  # ForkCast-v1, ForkCast-v2

# Template-based workspaces
setup-dual-environments.bat 1 templates/recipe-discovery
setup-dual-environments.bat 2 templates/meal-planning
```

## Workspace Creation Process

### Documentation-Driven Workflow

1. **Feature Validation**: Script validates `docs/sandbox/[feature-name]/` directory exists
2. **Foundation Check**: Ensures at least one `00-*-foundation.md` file exists
3. **Methodology Discovery**: Automatically detects numbered methodology files (`01-*.md`, `02-*.md`, etc.)
4. **Workspace Generation**: Creates separate workspace for each methodology
5. **Documentation Copying**: Copies foundation and methodology documents to each workspace
6. **Git Branch Creation**: Creates methodology-specific branches
7. **Dependency Installation**: Installs individual dependencies for each workspace

### File Copying Strategy

**Foundation Document**: `00-*-foundation.md` → `FEATURE_FOUNDATION.md` (copied to all workspaces)
**Methodology Document**: `01-*-methodology.md` → `METHODOLOGY_GUIDE.md` (specific to each workspace)
**Repository Files**: Complete ForkCast codebase preserved in each workspace
**Package Metadata**: Methodology identifier added to workspace package.json

## Methodology Name Processing

### Automatic Name Extraction

The script automatically extracts methodology names from filenames:

```
01-design-tokens-first-methodology.md → design-tokens-first
02-feature-driven-methodology.md → feature-driven
03-component-library-methodology.md → component-library
```

### Character Sanitization

Special characters and spaces are automatically converted to hyphens:

```
01-oauth 2.0_methodology.md → oauth-2-0
02-session based-methodology.md → session-based
03-jwt/token_methodology.md → jwt-token
```

## Validation and Error Handling

### Feature Directory Validation

```cmd
# Error: Feature directory not found
Error: Documentation feature directory 'docs/sandbox/nonexistent/' not found.

Available documentation-driven features:
  ✓ docs/sandbox/design-system
  ✓ docs/sandbox/authentication
  ✗ docs/sandbox/incomplete-feature (missing foundation file)
```

### Foundation Document Requirement

```cmd
# Error: Missing foundation document
Error: No foundation document (00-*-foundation.md) found in 'docs/sandbox/feature-name/'.
```

### Methodology File Discovery

```cmd
# Error: No methodology files found
Error: No methodology files (01-*.md, 02-*.md, etc.) found in 'docs/sandbox/feature-name/'.
```

## Integration with Existing Features

### Maintained Functionality

- ✅ Individual dependency installation and verification
- ✅ Git branch creation and management
- ✅ Workspace switcher generation
- ✅ Performance optimization and bundle analysis
- ✅ Template-based workspace creation
- ✅ Standard workspace creation

### Enhanced Features

- ✅ Methodology-specific workspace naming
- ✅ Documentation-driven file copying
- ✅ Feature validation and discovery
- ✅ Enhanced summary output with methodology information
- ✅ Comprehensive error handling and user guidance

## Practical Examples

### Design System Development

```cmd
# Create design system methodology workspaces
setup-dual-environments.bat 1 docs-driven design-system

# Results in:
# - ForkCast-design-tokens-first-v1/
#   ├── FEATURE_FOUNDATION.md (design system foundation)
#   ├── METHODOLOGY_GUIDE.md (design tokens first approach)
#   └── [complete ForkCast codebase]
# - ForkCast-feature-driven-v1/
#   ├── FEATURE_FOUNDATION.md (design system foundation)
#   ├── METHODOLOGY_GUIDE.md (feature-driven approach)
#   └── [complete ForkCast codebase]
# - ForkCast-component-library-v1/
#   ├── FEATURE_FOUNDATION.md (design system foundation)
#   ├── METHODOLOGY_GUIDE.md (component library approach)
#   └── [complete ForkCast codebase]
```

### Authentication Feature Development

```cmd
# Create authentication methodology workspaces
setup-dual-environments.bat 2 docs-driven authentication

# Potential results (if docs/sandbox/authentication/ exists):
# - ForkCast-oauth-v1/, ForkCast-oauth-v2/
# - ForkCast-session-based-v1/, ForkCast-session-based-v2/
# - ForkCast-jwt-token-v1/, ForkCast-jwt-token-v2/
```

## Testing and Validation

### Test Script Usage

```cmd
# Run comprehensive functionality tests
test-docs-driven-functionality.bat

# Tests include:
# - Feature directory validation
# - Foundation document detection
# - Methodology file discovery
# - Name extraction and sanitization
# - Workspace name generation
```

### Manual Validation

```cmd
# List available features
setup-dual-environments.bat 1 docs-driven nonexistent

# Show help with new usage patterns
setup-dual-environments.bat --help
```

## Benefits and Use Cases

### Development Strategy Exploration

- **Parallel Development**: Teams can explore multiple implementation approaches simultaneously
- **Risk Mitigation**: Test different strategies before committing to one approach
- **Knowledge Sharing**: Documentation-driven approach ensures methodology knowledge is preserved

### Team Collaboration

- **Methodology Isolation**: Each approach has dedicated workspace and Git branch
- **Clear Documentation**: Foundation and methodology documents provide context
- **Consistent Setup**: Automated workspace creation ensures team consistency

### Feature Development Workflows

- **Design Systems**: Compare token-first vs. component-first approaches
- **Authentication**: Evaluate OAuth vs. session-based vs. JWT strategies
- **Payment Processing**: Test different payment gateway integration approaches
- **API Design**: Compare REST vs. GraphQL vs. tRPC implementations

## Migration and Adoption

### Gradual Adoption

1. **Create Documentation Structure**: Set up `docs/sandbox/[feature-name]/` directories
2. **Write Foundation Documents**: Document shared knowledge and requirements
3. **Define Methodologies**: Create methodology-specific implementation guides
4. **Test Workspace Creation**: Validate setup with test runs
5. **Team Training**: Train team on new documentation-driven workflows

### Best Practices

1. **Comprehensive Foundation Documents**: Include all shared knowledge and requirements
2. **Clear Methodology Separation**: Ensure each methodology document focuses on specific approach
3. **Consistent Naming**: Use descriptive, hyphen-separated methodology names
4. **Regular Updates**: Keep documentation synchronized with implementation learnings
5. **Team Collaboration**: Use methodology workspaces for collaborative exploration

## Future Enhancements

### Potential Improvements

- **Interactive Methodology Selection**: Menu-driven selection of specific methodologies
- **Methodology Dependencies**: Support for methodology-specific package installations
- **Documentation Templates**: Standardized templates for foundation and methodology documents
- **Workspace Comparison Tools**: Utilities for comparing methodology implementations
- **Remote Documentation**: Support for documentation from external repositories

This documentation-driven enhancement transforms the ForkCast setup script into a powerful tool for exploring different development approaches while maintaining complete backward compatibility and reliability.
