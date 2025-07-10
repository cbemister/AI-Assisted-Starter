# Project State Context Template

## Project Overview
**Project Name**: {{PROJECT_NAME}}
**Methodology**: {{METHODOLOGY}}
**Current Phase**: {{CURRENT_PHASE}}
**Start Date**: {{START_DATE}}
**Last Updated**: {{LAST_UPDATED}}

## Methodology Configuration
**Primary Methodology**: {{PRIMARY_METHODOLOGY}}
**Secondary Methodology**: {{SECONDARY_METHODOLOGY}} (if hybrid)
**Methodology Rationale**: {{METHODOLOGY_SELECTION_REASON}}

### Methodology Scores
- User-Centric: {{USER_CENTRIC_SCORE}}/10
- Technology-Innovation: {{TECH_INNOVATION_SCORE}}/10
- Business-Value: {{BUSINESS_VALUE_SCORE}}/10

## Project Requirements
**Problem Statement**: {{PROBLEM_STATEMENT}}
**Target Users**: {{TARGET_USERS}}
**Success Criteria**: {{SUCCESS_CRITERIA}}
**Key Constraints**: {{KEY_CONSTRAINTS}}

## Technology Stack
**Frontend**: {{FRONTEND_TECHNOLOGY}}
**Backend**: {{BACKEND_TECHNOLOGY}}
**Database**: {{DATABASE_TECHNOLOGY}}
**Deployment**: {{DEPLOYMENT_PLATFORM}}

## Current Status
**Completed Phases**: {{COMPLETED_PHASES}}
**Current Activities**: {{CURRENT_ACTIVITIES}}
**Next Milestones**: {{NEXT_MILESTONES}}
**Blockers/Issues**: {{CURRENT_BLOCKERS}}

## Key Decisions Made
{{#each DECISIONS}}
- **{{date}}**: {{decision}} (Rationale: {{rationale}})
{{/each}}

## Methodology-Specific Context

### User-Centric Context (if applicable)
**User Research Findings**: {{USER_RESEARCH_SUMMARY}}
**Accessibility Requirements**: {{ACCESSIBILITY_REQUIREMENTS}}
**User Testing Results**: {{USER_TESTING_RESULTS}}
**User Feedback**: {{USER_FEEDBACK_SUMMARY}}

### Technology-Innovation Context (if applicable)
**Innovation Goals**: {{INNOVATION_GOALS}}
**Technical Benchmarks**: {{PERFORMANCE_BENCHMARKS}}
**Technology Experiments**: {{TECH_EXPERIMENTS}}
**Competitive Analysis**: {{COMPETITIVE_TECH_ANALYSIS}}

### Business-Value Context (if applicable)
**Business Objectives**: {{BUSINESS_OBJECTIVES}}
**ROI Projections**: {{ROI_PROJECTIONS}}
**Stakeholder Requirements**: {{STAKEHOLDER_REQUIREMENTS}}
**Market Analysis**: {{MARKET_ANALYSIS}}

## AI Assistant Instructions
When providing assistance for this project:

1. **Always consider the {{METHODOLOGY}} methodology principles**
2. **Prioritize decisions based on {{METHODOLOGY}} evaluation criteria**
3. **Reference previous decisions and context when making recommendations**
4. **Maintain consistency with established project direction and constraints**
5. **Focus on {{METHODOLOGY}}-specific success metrics and validation**

### Methodology-Specific AI Guidance

{{#if METHODOLOGY == "user-centric"}}
**User-Centric Focus**:
- Prioritize user experience and accessibility in all recommendations
- Always consider impact on user satisfaction and task completion
- Validate suggestions against user research findings
- Ensure accessibility compliance (WCAG 2.1 AA) in all solutions
- Focus on user feedback integration and validation
{{/if}}

{{#if METHODOLOGY == "technology-innovation"}}
**Technology-Innovation Focus**:
- Prioritize technical excellence and performance optimization
- Consider cutting-edge technologies and innovative approaches
- Validate suggestions against performance benchmarks
- Focus on competitive technical advantages
- Emphasize technical best practices and advanced patterns
{{/if}}

{{#if METHODOLOGY == "business-value"}}
**Business-Value Focus**:
- Prioritize business outcomes and ROI in all recommendations
- Consider cost-effectiveness and resource optimization
- Validate suggestions against business objectives
- Focus on stakeholder satisfaction and business metrics
- Emphasize measurable business value delivery
{{/if}}

## Context Injection Prompt
```
I'm working on "{{PROJECT_NAME}}" using {{METHODOLOGY}} methodology.

Current project context:
- Phase: {{CURRENT_PHASE}}
- Problem: {{PROBLEM_STATEMENT}}
- Technology: {{TECHNOLOGY_STACK}}
- Methodology Focus: {{METHODOLOGY_PRIORITIES}}

Previous decisions and context:
{{DECISION_HISTORY}}

Please provide assistance that:
1. Aligns with {{METHODOLOGY}} methodology principles
2. Considers the established project context and decisions
3. Maintains consistency with our chosen technology stack
4. Focuses on {{METHODOLOGY}}-specific success criteria

Question: {{USER_QUESTION}}
```

## Context Update Instructions
Update this template whenever:
- [ ] Phase transitions occur
- [ ] Major decisions are made
- [ ] Technology choices change
- [ ] Requirements are modified
- [ ] Methodology adjustments are needed
- [ ] Significant progress milestones are reached

## Context Preservation Checklist
- [ ] Project overview is current and accurate
- [ ] Methodology configuration reflects current approach
- [ ] Technology stack is up to date
- [ ] Key decisions are documented with rationale
- [ ] Current status reflects actual progress
- [ ] Methodology-specific context is comprehensive
- [ ] AI instructions are clear and actionable
