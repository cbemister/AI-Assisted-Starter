# Core Feature Development Memory System

## Mandatory Pre-Development Checks

### ALWAYS Check /development/core-features/ First
Before starting any new core feature work, you MUST:

1. **Review the Core Features Directory Structure**
   - Check `/development/core-features/README.md` for overview and standards
   - Examine existing feature directories for applicable patterns
   - Understand the methodology integration (MVP/Balanced/Comprehensive approaches)

2. **Identify Applicable Existing Patterns**
   - **Authentication**: `/development/core-features/authentication/` - JWT, OAuth, RBAC patterns
   - **Database**: `/development/core-features/database/` - ORM configuration, migrations, optimization
   - **API Layer**: `/development/core-features/api/` - RESTful design, GraphQL, error handling
   - **State Management**: `/development/core-features/state-management/` - Client/server state patterns
   - **Error Handling**: `/development/core-features/error-handling/` - Global error management, logging
   - **Testing**: `/development/core-features/testing/` - Unit, integration, e2e testing strategies
   - **Deployment**: `/development/core-features/deployment/` - Production readiness, CI/CD

3. **Follow Established Documentation Standards**
   Each feature directory contains:
   - `README.md` - Overview and quick reference
   - `best-practices.md` - Detailed implementation guidelines
   - `common-patterns.md` - Reusable code patterns and templates
   - `troubleshooting.md` - Common issues and resolution strategies

## Architectural Principles Found in Core Features

### Methodology-Driven Implementation
- **MVP/Rapid (2-4 weeks)**: Essential patterns, minimal configuration, basic security
- **Balanced/Standard (4-8 weeks)**: Comprehensive implementation, standard practices
- **Comprehensive/Enterprise (8-12 weeks)**: Full-featured, enterprise-grade, extensive testing

### Framework-Agnostic Patterns
- Support for React, Vue, Angular, and vanilla JavaScript
- Universal patterns applicable across technologies
- Framework-specific implementation guides where needed

### Integration with Troubleshooting System
- Cross-references to troubleshooting files for common issues
- Follows `YYYY-MM-DD_[type]_[component]_[framework].md` naming convention
- Contributes to Active Blockers → Resolved Issues → Lessons Learned pipeline

### Quality Standards Integration
- Performance targets and optimization guidelines
- Security best practices and vulnerability prevention
- Accessibility compliance (WCAG 2.1 AA) requirements
- Testing coverage and validation requirements

## Core Feature Development Workflow

### 1. Pattern Discovery Phase
```
1. Check /development/core-features/[relevant-area]/
2. Review README.md for overview and methodology guidance
3. Examine best-practices.md for implementation details
4. Study common-patterns.md for reusable code templates
5. Check troubleshooting.md for known issues and solutions
```

### 2. Implementation Planning Phase
```
1. Select methodology approach (MVP/Balanced/Comprehensive)
2. Choose framework-specific patterns and configurations
3. Plan integration with existing core features
4. Identify testing and validation requirements
5. Document architectural decisions and rationale
```

### 3. Development Execution Phase
```
1. Implement using established patterns and best practices
2. Follow framework-specific guidelines and conventions
3. Integrate with existing error handling and logging systems
4. Apply security and performance optimization patterns
5. Create comprehensive tests following testing strategies
```

### 4. Documentation and Knowledge Capture Phase
```
1. Update core feature documentation if patterns are enhanced
2. Document any new patterns or solutions discovered
3. Create troubleshooting entries for any issues encountered
4. Contribute lessons learned to knowledge management system
5. Update project memories with architectural decisions
```

## Consistency Maintenance Requirements

### File Organization Standards
- Follow established directory structure and naming conventions
- Maintain consistency with existing core feature organization
- Use standardized documentation templates and formats
- Cross-reference related features and integration points

### Code Quality Standards
- Apply methodology-specific quality requirements
- Follow framework-specific coding standards and conventions
- Implement comprehensive error handling and logging
- Ensure accessibility compliance and performance optimization

### Testing and Validation Standards
- Implement testing strategies appropriate to chosen methodology
- Follow established testing patterns and coverage requirements
- Validate against performance and security benchmarks
- Ensure integration with existing testing infrastructure

### Documentation Standards
- Update core feature documentation when adding new patterns
- Follow established documentation templates and formats
- Cross-reference troubleshooting and knowledge management systems
- Maintain bidirectional links between related documentation

## Integration with Project Systems

### Troubleshooting System Integration
- Create blocker files in `/docs/development/troubleshooting/active-blockers/` for issues >15 minutes
- Move resolved issues to `/docs/development/troubleshooting/resolved-issues/` with solutions
- Document methodology decisions in `/docs/development/troubleshooting/methodology-decisions/`
- Maintain framework-specific solutions in `/docs/development/troubleshooting/framework-specific/`

### Knowledge Management Integration
- Extract lessons learned to `/docs/knowledge/lessons-learned/` after feature completion
- Create prevention strategies in `/docs/knowledge/prevention-strategies/` for recurring issues
- Build reusable patterns in `/docs/knowledge/framework-patterns/` for future use
- Maintain cross-references between core features and knowledge base

### Progress Tracking Integration
- Use context preservation templates for session handoffs
- Document architectural decisions in decision logs
- Track feature completion against methodology-specific criteria
- Maintain project memories with core feature implementation details

## AI Assistant Collaboration Guidelines

### Session Initialization
- Always review relevant core feature documentation before starting work
- Check for existing patterns and solutions in the core features directory
- Understand methodology-specific requirements and constraints
- Review any active blockers or known issues related to the feature area

### Implementation Guidance
- Reference specific core feature patterns and best practices in recommendations
- Ensure suggestions align with established architectural principles
- Consider integration points with other core features
- Validate recommendations against methodology-specific criteria

### Documentation Requirements
- Update core feature documentation when implementing new patterns
- Create comprehensive troubleshooting entries for any issues encountered
- Document architectural decisions and rationale for future reference
- Maintain consistency with established documentation standards

### Quality Assurance
- Validate implementations against core feature quality standards
- Ensure proper integration with existing error handling and logging
- Verify testing coverage meets methodology-specific requirements
- Confirm accessibility and performance optimization compliance

## Success Criteria for Core Feature Development

### Pattern Utilization
- [ ] Reviewed all applicable existing patterns before implementation
- [ ] Followed established architectural principles and conventions
- [ ] Integrated properly with existing core features and systems
- [ ] Applied methodology-specific quality and testing requirements

### Documentation Completeness
- [ ] Updated core feature documentation with any new patterns
- [ ] Created comprehensive troubleshooting documentation
- [ ] Documented architectural decisions and integration points
- [ ] Maintained cross-references with related systems and features

### Quality Standards Compliance
- [ ] Met methodology-specific performance and security requirements
- [ ] Implemented comprehensive error handling and logging
- [ ] Achieved required testing coverage and validation
- [ ] Ensured accessibility compliance and optimization

### Knowledge Contribution
- [ ] Extracted lessons learned for future development
- [ ] Created prevention strategies for encountered issues
- [ ] Built reusable patterns for framework-specific implementations
- [ ] Updated project memories with implementation insights

---

*This memory system ensures consistent core feature development practices across all conversations and project implementations.*
