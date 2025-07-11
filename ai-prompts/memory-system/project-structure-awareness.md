# Project Structure Awareness Memory System

## Complete AI-Assisted-Starter Directory Structure

### Root Level Organization
```
ai-assisted-starter/                    # Complete methodology toolkit
├── README.md                           # Toolkit overview and usage instructions
├── setup-dual-environments.bat        # Windows script for multi-version project setup
├── ai-prompts/                         # AI prompt templates and memory system
├── templates/                          # Reusable document templates
├── methodologies/                      # Philosophy-based approach modules
├── workflows/                          # Step-by-step development processes
├── docs/                              # Comprehensive development guides
├── development/                        # Core feature implementation guides
└── sandbox/                           # Development workspace area
```

## Directory-by-Directory Structure and Purpose

### `/ai-prompts/` - AI Assistant Integration
```
ai-prompts/
├── new-project-setup-prompt.md        # Standalone project initialization prompt
├── memory-system/                     # Persistent memory files for consistent behavior
│   ├── core-feature-development.md    # Core features mandatory checks and patterns
│   ├── template-usage-guidelines.md   # Comprehensive template mapping and usage
│   └── project-structure-awareness.md # This file - project organization awareness
├── conception/                        # Project conception prompts
│   └── user-centric/                  # User-centric methodology conception prompts
├── context-preservation/              # Context management prompts
│   └── project-state-template.md      # Project state context template
├── prompt-chains/                     # Multi-step prompt workflows
│   └── conception-to-development.md   # Feature development chain prompts
└── README.md                          # AI prompts system overview and usage
```

### `/templates/` - Reusable Document Templates
```
templates/
├── feature-planning-template.md       # Feature specification template
├── prd-template.md                    # Product Requirements Document template
├── roadmap-template.md                # Project roadmap template
├── knowledge/                         # Knowledge management templates
│   ├── README.md                      # Knowledge management overview
│   ├── lessons-learned/               # Lesson documentation templates
│   └── prevention-strategies/         # Prevention strategy templates
├── progress/                          # Progress tracking templates
│   ├── README.md                      # Progress tracking overview
│   └── context-preservation/          # Session handoff documentation
└── troubleshooting/                   # Troubleshooting framework
    ├── README.md                      # Troubleshooting system overview
    ├── active-blockers/               # Current issue tracking
    ├── resolved-issues/               # Solution documentation
    ├── framework-specific/            # Technology-specific solutions
    └── methodology-decisions/         # Decision documentation
```

### `/development/core-features/` - Implementation Patterns
```
development/core-features/
├── README.md                          # Core features overview and standards
├── api/                               # API development patterns
│   └── README.md                      # API implementation guidelines
├── authentication/                    # Auth implementation guides
│   ├── README.md                      # Authentication overview
│   ├── best-practices.md              # Security best practices
│   ├── common-patterns.md             # Reusable auth patterns
│   └── troubleshooting.md             # Auth troubleshooting guide
├── database/                          # Data layer patterns
│   ├── README.md                      # Database implementation overview
│   └── best-practices.md              # Database optimization guidelines
├── deployment/                        # Production deployment guides
│   └── README.md                      # Deployment strategies overview
├── error-handling/                    # Error management strategies
│   └── README.md                      # Error handling patterns
├── state-management/                  # State management patterns
│   └── README.md                      # State management strategies
└── testing/                          # Testing strategies and patterns
    └── README.md                      # Testing implementation guide
```

### `/docs/` - Comprehensive Development Guides
```
docs/
├── AUGMENT_MEMORIES.txt               # Project memories template with placeholders
├── DOCS_DRIVEN_ENHANCEMENT_GUIDE.md  # Documentation-driven development guide
├── IMPLEMENTATION_SUMMARY.md          # Toolkit implementation details
├── SESSION_RECOVERY_PROCESS.md        # Context recovery procedures
├── SOLO_DEVELOPMENT_BEST_PRACTICES.md # Solo developer workflows
├── TROUBLESHOOTING_PROTOCOL.md        # Structured problem-solving framework
└── _QUICK_START.md                    # AI assistant prompt examples
```

### `/methodologies/` - Philosophy-Based Modules
```
methodologies/
├── business-value/                    # Business outcome focused modules
├── design-concepts/                   # Design philosophy modules
├── technology-innovation/             # Technical excellence focused modules
└── user-centric/                     # User experience focused modules
```

### `/workflows/` - Development Process Scripts
```
workflows/
├── methodology-decision-tree.md       # Decision framework documentation
├── methodology-selection.sh           # Interactive methodology selection
├── generate-prd.sh                   # AI-assisted PRD generation
└── phase-transition.sh               # Phase transition guidance
```

## File Organization Principles

### Naming Conventions
- **Component files**: PascalCase (e.g., UserProfile.tsx, NavigationMenu.vue)
- **Utility functions**: camelCase (e.g., formatDate.ts, validateEmail.js)
- **Test files**: Mirror source with .test or .spec suffix
- **Documentation files**: kebab-case (e.g., api-documentation.md, deployment-guide.md)
- **Configuration files**: lowercase with extensions (e.g., package.json, tsconfig.json)
- **Directory names**: kebab-case for features, camelCase for utilities
- **Troubleshooting files**: `YYYY-MM-DD_[type]_[component]_[framework].md`

### Directory Hierarchy Principles
1. **Logical Grouping**: Related functionality grouped in common directories
2. **Methodology Integration**: Structure supports all three methodology approaches
3. **Framework Agnostic**: Organization works across React, Vue, Angular, vanilla JS
4. **Scalability**: Structure accommodates project growth and complexity
5. **Cross-References**: Clear relationships between related directories

### Documentation Standards
- **README.md**: Every directory has overview and quick reference
- **Cross-References**: Bidirectional links between related documentation
- **Template Integration**: Consistent use of template system across directories
- **Methodology Alignment**: Documentation supports chosen methodology approach

## Pattern Recognition and Consistency

### Before Creating New Files
1. **Check Existing Patterns**: Review similar files in the same directory
2. **Follow Naming Conventions**: Use established naming patterns
3. **Reference Templates**: Use appropriate templates from `/templates/`
4. **Maintain Cross-References**: Link to related documentation
5. **Consider Methodology**: Align with chosen methodology approach

### Before Creating New Directories
1. **Review Existing Structure**: Understand current organization principles
2. **Check for Existing Location**: Ensure new directory is necessary
3. **Follow Hierarchy Principles**: Maintain logical grouping and relationships
4. **Create Supporting Documentation**: Include README.md and overview files
5. **Update Cross-References**: Link from related directories and documentation

### File Placement Decision Matrix

#### Documentation Files
- **Project-wide guides**: `/docs/`
- **Feature-specific docs**: `/development/core-features/[feature]/`
- **Template files**: `/templates/[category]/`
- **AI prompts**: `/ai-prompts/[category]/`
- **Methodology guides**: `/methodologies/[approach]/`

#### Implementation Files
- **Core feature patterns**: `/development/core-features/[feature]/`
- **Workflow scripts**: `/workflows/`
- **Development workspace**: `/sandbox/`
- **Project-specific code**: Create new directories as needed

#### Knowledge Management Files
- **Active issues**: `/templates/troubleshooting/active-blockers/`
- **Resolved solutions**: `/templates/troubleshooting/resolved-issues/`
- **Lessons learned**: `/templates/knowledge/lessons-learned/`
- **Prevention strategies**: `/templates/knowledge/prevention-strategies/`

## Integration Points and Cross-References

### Documentation Flow Patterns
```
Core Features ↔ Templates ↔ Troubleshooting ↔ Knowledge Management
     ↓              ↓              ↓              ↓
AI Prompts ↔ Methodologies ↔ Workflows ↔ Project Documentation
```

### Mandatory Cross-Reference Points
1. **Core Features → Templates**: Reference applicable templates in feature documentation
2. **Templates → Troubleshooting**: Link troubleshooting guides in template usage
3. **Troubleshooting → Knowledge**: Extract lessons from resolved issues
4. **AI Prompts → All Directories**: Reference project structure in AI interactions
5. **Methodologies → Implementation**: Apply methodology principles in all development

### Consistency Maintenance Requirements
- **Update Related Files**: When modifying any file, check for related documentation
- **Maintain Bidirectional Links**: Ensure cross-references work in both directions
- **Follow Template Standards**: Use established templates for new documentation
- **Preserve Methodology Alignment**: Ensure changes support all methodology approaches

## AI Assistant Integration Guidelines

### Structure-Aware Development
1. **Always Reference Existing Patterns**: Check similar files before creating new ones
2. **Follow Established Organization**: Maintain consistency with existing structure
3. **Use Appropriate Templates**: Select templates based on file type and purpose
4. **Maintain Cross-References**: Update related documentation when making changes

### Directory Navigation for AI
- **Start with README files**: Understand directory purpose and organization
- **Check for existing patterns**: Review similar files for consistency
- **Follow naming conventions**: Use established patterns for new files
- **Maintain documentation standards**: Include overview and cross-reference information

### Project State Awareness
- **Understand Current Structure**: Know what directories and files exist
- **Recognize Patterns**: Identify established conventions and standards
- **Maintain Consistency**: Follow existing organization principles
- **Update Documentation**: Keep structure documentation current

## Success Criteria for Structure Awareness

### Consistent File Organization
- [ ] New files follow established naming conventions
- [ ] Directory placement follows logical grouping principles
- [ ] Documentation standards maintained across all files
- [ ] Cross-references updated when creating or modifying files

### Pattern Recognition
- [ ] Existing patterns identified before creating new implementations
- [ ] Similar files reviewed for consistency and standards
- [ ] Template system used appropriately for new documentation
- [ ] Methodology alignment maintained in all new content

### Integration Maintenance
- [ ] Related documentation updated when making changes
- [ ] Cross-references maintained bidirectionally
- [ ] Knowledge management workflows followed
- [ ] AI prompt system updated with structural changes

### Documentation Quality
- [ ] README files created for new directories
- [ ] Overview documentation maintained for complex structures
- [ ] Template usage documented and cross-referenced
- [ ] Methodology integration preserved in all documentation

---

*This memory system ensures consistent project structure awareness and file organization across all development activities and AI interactions.*
