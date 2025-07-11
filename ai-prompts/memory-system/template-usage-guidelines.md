# Template Usage Guidelines Memory System

## Comprehensive Template Directory Mapping

### Root Level Templates (`/templates/`)

#### 1. Feature Planning Template (`feature-planning-template.md`)
**When to Use**: Before starting any new feature development
**Purpose**: Structured approach to feature specification and planning
**Key Sections**: Requirements, user stories, technical specifications, acceptance criteria
**Integration**: Links to core features documentation and methodology guidance

#### 2. PRD Template (`prd-template.md`)
**When to Use**: During project initialization and major feature planning
**Purpose**: Product Requirements Document creation with methodology alignment
**Key Sections**: Problem statement, solution approach, success metrics, technical requirements
**Integration**: Works with methodology selection and project setup workflows

#### 3. Roadmap Template (`roadmap-template.md`)
**When to Use**: Project planning and milestone definition phases
**Purpose**: Strategic planning and timeline management
**Key Sections**: Phase breakdown, milestone definitions, methodology-specific goals
**Integration**: Aligns with 8-phase project lifecycle and methodology approaches

### Knowledge Management Templates (`/templates/knowledge/`)

#### Directory Structure and Purpose
- **`/lessons-learned/`**: Cross-project applicable insights and learning extraction
- **`/prevention-strategies/`**: Proactive problem avoidance and risk mitigation
- **`/framework-patterns/`**: Technology-specific best practices and reusable patterns

#### When to Use Knowledge Templates
1. **After Resolving Major Issues**: Extract lessons learned for future prevention
2. **Feature Completion**: Document patterns and insights for reuse
3. **Methodology Decisions**: Capture decision rationale and outcomes
4. **Framework Integration**: Document successful integration patterns

#### Knowledge Template Categories
- **Problem Categories**: css-modules, design-tokens, build-tools, performance, accessibility
- **Solution Types**: configuration, architecture, optimization, integration, workflow
- **Framework Applicability**: react, vue, angular, vanilla-js, universal, cross-framework

#### Knowledge Quality Standards
- [ ] Problem context with clear description and circumstances
- [ ] Complete solution details with code examples
- [ ] Applicability scope and framework-specific considerations
- [ ] Methodology alignment and prevention potential

### Progress Tracking Templates (`/templates/progress/`)

#### Context Preservation Subdirectory (`/context-preservation/`)
**When to Use**: End of each development session or before major transitions
**Purpose**: Maintain project context across AI sessions and development periods
**Key Components**: Current task state, completed work, pending decisions, known issues

#### Progress Template Usage Workflow
1. **Session Start**: Review previous context preservation documents
2. **During Development**: Update progress incrementally
3. **Session End**: Create comprehensive handoff documentation
4. **Milestone Completion**: Archive and summarize progress

#### Integration with AI Assistance
- Use context preservation for consistent AI assistance across sessions
- Reference progress templates when asking for development guidance
- Maintain project state for effective AI collaboration

### Troubleshooting Templates (`/templates/troubleshooting/`)

#### Active Blockers Subdirectory (`/active-blockers/`)
**When to Use**: Immediately when encountering issues that halt development >15 minutes
**Purpose**: Systematic issue tracking and resolution management
**Required Sections**: Problem description, impact assessment, attempted solutions, current status

#### Resolved Issues Subdirectory (`/resolved-issues/`)
**When to Use**: After successfully resolving any documented blocker
**Purpose**: Solution documentation and knowledge capture
**Required Sections**: Final solution, root cause analysis, time to resolution, prevention measures

#### Framework-Specific Subdirectory (`/framework-specific/`)
**When to Use**: For technology-specific issues and solutions
**Purpose**: Build framework-specific troubleshooting knowledge base
**Organization**: Separate subdirectories for React, Vue, Angular, vanilla JS

#### Methodology Decisions Subdirectory (`/methodology-decisions/`)
**When to Use**: When making or changing methodology selections
**Purpose**: Document methodology choices and rationale
**Required Sections**: Decision rationale, trade-offs, success criteria, rollback conditions

## Template Selection Decision Matrix

### By Development Phase
1. **Project Initialization**: PRD Template, Roadmap Template, Methodology Decision Templates
2. **Feature Planning**: Feature Planning Template, Core Features Documentation
3. **Active Development**: Progress Templates, Active Blockers Templates
4. **Issue Resolution**: Troubleshooting Templates, Resolved Issues Templates
5. **Knowledge Capture**: Lessons Learned Templates, Prevention Strategy Templates

### By Methodology Approach
- **MVP/Rapid (2-4 weeks)**: Focus on essential templates, minimal documentation overhead
- **Balanced/Standard (4-8 weeks)**: Standard template usage, moderate documentation
- **Comprehensive/Enterprise (8-12 weeks)**: Full template system, extensive documentation

### By Problem Type
- **Technical Issues**: Framework-Specific Templates, Core Features Documentation
- **Process Issues**: Methodology Decision Templates, Progress Templates
- **Knowledge Gaps**: Lessons Learned Templates, Prevention Strategy Templates
- **Planning Needs**: Feature Planning Templates, Roadmap Templates

## Template Customization Guidelines

### Variable Placeholder System
All templates include standardized placeholders:
- `{{PROJECT_NAME}}` - Your specific project name
- `{{METHODOLOGY}}` - Selected methodology approach
- `{{PHASE}}` - Current development phase
- `{{FEATURE_NAME}}` - Specific feature being developed
- `{{FRAMEWORK}}` - Chosen technology framework

### Methodology-Specific Customization
Templates adapt to methodology selection:
- **User-Centric**: Focus on user experience and accessibility requirements
- **Technology-Innovation**: Emphasize technical excellence and performance
- **Business-Value**: Prioritize business outcomes and ROI considerations

### Framework-Specific Adaptations
Templates include framework-specific guidance:
- **React/Next.js**: Component architecture and state management patterns
- **Vue/Nuxt.js**: Composition API and module organization
- **Angular**: Dependency injection and service architecture
- **Vanilla JS**: Module system and build tool configuration

## Template Integration Workflows

### Knowledge Flow Pipeline
```
Active Blockers → Resolved Issues → Lessons Learned → Prevention Strategies → Framework Patterns
```

### Documentation Consistency Requirements
- Use consistent terminology and formatting across all templates
- Maintain cross-references between related templates and documentation
- Follow established naming conventions: `YYYY-MM-DD_[type]_[component]_[framework].md`
- Update related templates when making changes to any single template

### Cross-Directory Integration
- **Troubleshooting ↔ Knowledge**: Extract lessons from resolved issues
- **Progress ↔ Planning**: Update roadmaps based on progress tracking
- **Core Features ↔ Templates**: Reference patterns in feature planning
- **Methodology ↔ All Templates**: Ensure methodology alignment across all documentation

## Template Maintenance and Updates

### Regular Review Schedule
- **Weekly**: Review active blockers and progress templates
- **Monthly**: Archive resolved issues and update prevention strategies
- **Quarterly**: Review and update framework patterns and lessons learned
- **Per Project**: Customize templates for project-specific needs

### Template Evolution Guidelines
- Update templates based on project experience and feedback
- Maintain backward compatibility with existing project documentation
- Document template changes and rationale for future reference
- Share template improvements across projects and teams

### Quality Assurance for Templates
- [ ] All placeholders are properly defined and documented
- [ ] Cross-references are accurate and up-to-date
- [ ] Methodology-specific guidance is comprehensive
- [ ] Framework-specific adaptations are current and accurate
- [ ] Integration workflows are clearly documented

## AI Assistant Template Integration

### Template Discovery Process
1. **Assess Current Need**: Identify what type of documentation or planning is needed
2. **Check Template Directory**: Review available templates for the specific need
3. **Select Appropriate Template**: Choose based on methodology, framework, and phase
4. **Customize for Context**: Replace placeholders with project-specific information

### Template Usage in AI Interactions
- Reference specific templates when asking for development guidance
- Use template structure to organize AI responses and recommendations
- Maintain template consistency across AI-assisted development sessions
- Update templates based on AI-generated insights and solutions

### Context Injection with Templates
- Use template content to provide project context to AI assistants
- Reference template decisions and documentation in AI interactions
- Maintain template-based project state for consistent AI assistance
- Leverage template cross-references for comprehensive AI guidance

## Success Criteria for Template Usage

### Effective Template Utilization
- [ ] Appropriate template selected for each development need
- [ ] Templates customized with accurate project-specific information
- [ ] Cross-references maintained between related templates
- [ ] Template-based workflows followed consistently

### Documentation Quality
- [ ] All required template sections completed thoroughly
- [ ] Methodology-specific guidance applied appropriately
- [ ] Framework-specific adaptations implemented correctly
- [ ] Integration with other project documentation maintained

### Knowledge Management Effectiveness
- [ ] Lessons learned captured systematically using templates
- [ ] Prevention strategies developed from template-based analysis
- [ ] Framework patterns documented for reuse
- [ ] Template-based knowledge flows maintained

### AI Integration Success
- [ ] Templates used effectively for AI context injection
- [ ] Template structure maintained in AI-assisted development
- [ ] Template-based project state preserved across sessions
- [ ] Template improvements identified and implemented

---

*This memory system ensures consistent and effective template usage across all development activities and AI interactions.*
