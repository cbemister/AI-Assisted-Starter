# Active Blockers Directory

**Purpose**: Track current unresolved issues that are blocking development progress

## When to Create Active Blocker Files

### Immediate Triggers
- [ ] Development halted for >15 minutes due to technical issue
- [ ] Error prevents build, test, or development server from running
- [ ] CSS Modules or design system conflict affecting multiple components
- [ ] Framework-specific issue requiring investigation beyond quick fixes
- [ ] Scope creep or methodology timeline threatened by technical complexity

### Methodology-Specific Thresholds
- **MVP/Rapid**: Any issue taking >30 minutes or affecting core features
- **Balanced/Standard**: Issues taking >60 minutes or affecting user experience
- **Comprehensive/Enterprise**: Issues taking >90 minutes or affecting architecture

## File Naming Convention

`YYYY-MM-DD_blocker_[component-name]_[issue-type]_[framework].md`

### Component Names
- Use kebab-case: `button-component`, `design-tokens`, `responsive-layout`
- Be specific: `user-profile-card` not just `card`
- Include system area: `build-configuration`, `css-modules-setup`

### Issue Types
- `css-modules`: Scoping, naming, or integration issues
- `design-tokens`: CSS custom property conflicts or inheritance
- `build-config`: Webpack, Vite, CLI configuration problems
- `framework-integration`: Technology-specific implementation issues
- `responsive-design`: Breakpoint, layout, or mobile compatibility
- `performance`: Bundle size, loading, or runtime performance
- `accessibility`: WCAG compliance or screen reader issues

### Framework Tags
- `react`: React/Next.js specific issues
- `vue`: Vue/Nuxt.js specific issues
- `angular`: Angular specific issues
- `vanilla-js`: Framework-agnostic JavaScript issues

## File Structure Template

Each active blocker file should include:

1. **Problem Statement** (2-3 sentences)
2. **Framework Context** (versions, tools, configuration)
3. **Reproduction Steps** (exact steps to reproduce)
4. **Attempted Solutions** (what's been tried with time invested)
5. **Impact Assessment** (timeline, scope, quality implications)
6. **Next Actions** (planned investigation steps)
7. **Escalation Criteria** (when to escalate or restart)

## Best Practices

### Documentation Standards
- **Be Immediate**: Create file within 5 minutes of recognizing blocker
- **Be Specific**: Include exact error messages and file paths
- **Be Methodical**: Document all attempted solutions with timestamps
- **Be Realistic**: Assess impact on methodology timeline honestly

### Update Frequency
- **Every 15 minutes**: Update with new attempts and findings
- **Every 30 minutes**: Reassess escalation criteria and next actions
- **At resolution**: Move to resolved-issues with complete solution

### Methodology Alignment
- **MVP/Rapid**: Focus on workarounds and scope reduction options
- **Balanced/Standard**: Balance investigation depth with timeline pressure
- **Comprehensive/Enterprise**: Thorough analysis with architectural considerations

## Integration Points

### Session Recovery Process
- Active blockers trigger session recovery triage
- Recovery process may create or update active blocker files
- Resolution moves blocker to resolved-issues directory

### Troubleshooting Protocol
- Active blockers follow troubleshooting time thresholds
- Decision matrices determine continue/pivot/escalate actions
- Framework-specific guidance informs resolution approaches

### Progress Tracking
- Active blockers impact weekly status reports
- Timeline implications feed into milestone validation
- Resolution times contribute to methodology planning

## Example File Names

```
2025-07-10_blocker_button-component_css-modules_react.md
2025-07-10_blocker_design-tokens_inheritance_vue.md
2025-07-10_blocker_build-configuration_webpack_angular.md
2025-07-10_blocker_responsive-layout_breakpoints_vanilla-js.md
2025-07-10_blocker_component-library_typescript_react.md
```

## Resolution Workflow

### When Issue is Resolved
1. **Document Solution**: Add complete resolution to active blocker file
2. **Move to Resolved**: Copy file to `../resolved-issues/` directory
3. **Extract Learning**: Create lesson learned file in `../../knowledge/lessons-learned/`
4. **Update Prevention**: Add prevention strategy if applicable
5. **Clean Up**: Remove from active-blockers directory

### When Issue Requires Restart
1. **Document Attempts**: Complete record of investigation efforts
2. **Preserve Knowledge**: Extract valuable insights before restart
3. **Move to Resolved**: Mark as "resolved-by-restart" with lessons
4. **Update Methodology**: Adjust timeline and scope as needed

## Cross-References

### Related Directories
- `../resolved-issues/`: Completed solutions and outcomes
- `../../progress/blockers/`: Timeline impact documentation
- `../../knowledge/lessons-learned/`: Extracted learning and patterns
- `../framework-specific/`: Technology-specific solutions and patterns

### Related Processes
- [Session Recovery Process](../../SESSION_RECOVERY_PROCESS.md)
- [Troubleshooting Protocol](../../TROUBLESHOOTING_PROTOCOL.md)
- [Progress Tracking Templates](../../../progress/README.md)
