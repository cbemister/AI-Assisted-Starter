# Development Troubleshooting Directory

**Purpose**: Central repository for active and resolved development issues in App Development projects

## Directory Structure

### `/active-blockers/`
**Purpose**: Current unresolved issues that are blocking development progress
**When to Use**: When encountering problems that halt development for >15 minutes
**Integration**: Links to Session Recovery Process and Troubleshooting Protocol

### `/resolved-issues/`
**Purpose**: Completed problem resolutions with detailed solutions
**When to Use**: After successfully resolving blockers, for knowledge preservation
**Integration**: Feeds into lessons-learned and prevention strategies

### `/methodology-decisions/`
**Purpose**: Framework and approach decisions made during troubleshooting
**When to Use**: When troubleshooting leads to architectural or methodology choices
**Integration**: Aligns with three-methodology framework (MVP/Balanced/Enterprise)

### `/framework-specific/`
**Purpose**: Technology-specific solutions and patterns
**When to Use**: For React, Vue, Angular, or vanilla JS specific issues
**Integration**: Framework-agnostic protocols with technology-specific implementations

## File Naming Conventions

All files follow the pattern: `YYYY-MM-DD_[type]_[component]_[issue-type]_[framework].md`

**Examples**:
- `2025-07-10_blocker_button-component_css-modules_react.md`
- `2025-07-10_resolved_design-tokens_inheritance_vue.md`
- `2025-07-10_decision_architecture_methodology-b_angular.md`
- `2025-07-10_pattern_responsive-design_vanilla-js.md`

## Best Practices

### Documentation Standards
1. **Be Specific**: Include exact error messages, file paths, and framework versions
2. **Include Context**: Methodology phase, timeline constraints, team capacity
3. **Document Attempts**: Record all attempted solutions with time invested
4. **Capture Learning**: Extract transferable knowledge for future projects

### Methodology Integration
- **MVP/Rapid**: Focus on quick fixes and scope reduction strategies
- **Balanced/Standard**: Balance quality and timeline considerations
- **Comprehensive/Enterprise**: Emphasize architectural soundness and long-term solutions

### Framework Considerations
- **React/Next.js**: Component lifecycle, hooks, SSR/SSG issues
- **Vue/Nuxt.js**: Single File Components, reactivity, Nuxt configuration
- **Angular**: Component encapsulation, CLI configuration, dependency injection
- **Vanilla JS**: Module systems, build tools, browser compatibility

## Cross-Directory Integration

### Workflow Connections
1. **Active Blocker** → **Session Recovery** → **Troubleshooting Protocol**
2. **Resolved Issue** → **Lessons Learned** → **Prevention Strategies**
3. **Methodology Decision** → **Decision Logs** → **Framework Patterns**

### Knowledge Flow
```
Active Blockers → Resolved Issues → Lessons Learned → Prevention Strategies
      ↓               ↓                    ↓                    ↓
Context Preservation → Decision Logs → Framework Patterns → Best Practices
```

## Quick Reference

### Emergency Triage (0-5 minutes)
1. Create active blocker file with immediate assessment
2. Follow Session Recovery Process for derailment
3. Use Troubleshooting Protocol for specific technical issues

### Resolution Documentation (5-10 minutes)
1. Move active blocker to resolved issues with solution
2. Extract lessons learned for knowledge base
3. Update prevention strategies if applicable

### Knowledge Building (10-15 minutes)
1. Identify patterns across resolved issues
2. Create framework-specific guidance
3. Update methodology decision documentation

## Integration with Enhanced Documentation Systems

### 🔧 Feature Development Integration
- [Feature Development Best Practices](../../project-lifecycle/feature-development/README.md) - Apply troubleshooting protocols to feature development workflows
- [Feature Planning Template](../../project-lifecycle/feature-development/feature-planning-template.md) - Identify potential issues during feature planning
- [Feature Completion Checklist](../../project-lifecycle/feature-development/feature-completion-checklist.md) - Include troubleshooting validation in completion criteria

### 📋 Project Lifecycle Integration
- [Project Lifecycle Framework](../../project-lifecycle/README.md) - Phase-specific troubleshooting strategies and escalation paths
- [Phase 4: Core Development](../../project-lifecycle/04-core-development/README.md) - Development-specific troubleshooting integration
- [Phase 5: Quality Assurance](../../project-lifecycle/05-quality-assurance/README.md) - Testing and validation troubleshooting

### 🛠️ Git Workflow Integration
- [Git Workflow and Policies](../../project-lifecycle/git-workflow/README.md) - Version control troubleshooting and conflict resolution
- [Git Conflict Resolution Guide](../GIT_CONFLICT_RESOLUTION_GUIDE.md) - Specialized Git troubleshooting strategies
- [Git Branches and Deployment Strategy](../GIT_BRANCHES_AND_DEPLOYMENT_STRATEGY.md) - Deployment troubleshooting workflows

### 🎯 Development Workflow Integration
- [Solo Development Best Practices](../SOLO_DEVELOPMENT_BEST_PRACTICES.md) - Individual developer troubleshooting workflows
- [Core Application Features](../../core-features/README.md) - Feature-specific troubleshooting patterns

## Related Documentation
- [Troubleshooting Protocol](../TROUBLESHOOTING_PROTOCOL.md)
- [Session Recovery Process](../SESSION_RECOVERY_PROCESS.md)
- [Enhanced Roadmap Template](../../_init/ROADMAP_TEMPLATE.md)
- [Progress Tracking](../../progress/README.md)
- [Knowledge Management](../../knowledge/README.md)
