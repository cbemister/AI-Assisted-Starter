# Development Troubleshooting and Recovery Protocol

**Version**: 1.0  
**Created**: July 2025  
**Purpose**: Framework-agnostic troubleshooting protocol for App Development projects  
**Compatibility**: All methodologies (MVP/Rapid, Balanced/Standard, Comprehensive/Enterprise)

## Overview

This protocol provides a structured, time-boxed approach to resolving development challenges while maintaining project momentum and preserving context across development sessions. It integrates with the three-methodology framework and supports all major frontend frameworks (React, Vue, Angular, vanilla JS).

## Quick Reference Decision Tree

### Universal Time Thresholds (Framework-Agnostic)

| Time Invested | Action Required | All Frameworks |
|---------------|----------------|----------------|
| **0-15 minutes** | Immediate assessment and quick fixes | Syntax errors, imports, basic CSS conflicts, build config |
| **15-30 minutes** | Deeper investigation and alternatives | Component architecture, design tokens, responsive issues |
| **30-60 minutes** | Methodology-specific decision point | Document rationale, consider pivot options |
| **60+ minutes** | Mandatory escalation or restart | Follow methodology-specific criteria below |

### Methodology-Specific Decision Criteria

#### MVP/Rapid (2-4 weeks)
- **Hard Stop**: 30 minutes maximum investigation
- **Scope Reduction Trigger**: 15% timeline impact
- **Accept Technical Debt**: Document for future cleanup
- **Framework Approach**: Use framework workarounds, avoid complex patterns

#### Balanced/Standard (4-8 weeks)
- **Investigation Limit**: 60 minutes with quality trade-offs
- **Refactoring Threshold**: <10% timeline impact
- **Quality Balance**: Moderate solutions with framework best practices

#### Comprehensive/Enterprise (8-12 weeks)
- **Extended Investigation**: 90+ minutes permitted
- **Architecture Priority**: Soundness over speed
- **Framework Standards**: Enterprise patterns required

### Critical Stop Triggers (All Methodologies)

**Immediate Escalation Required:**
- [ ] Breaking changes affecting 3+ components
- [ ] Security vulnerabilities in dependencies
- [ ] Fundamental design system architecture conflicts
- [ ] Timeline impact: >1 day (MVP), >2 days (Balanced), >3 days (Enterprise)

## Documentation System

### Required Folder Structure

```
docs/
├── development/
│   ├── troubleshooting/
│   │   ├── active-blockers/           # Current unresolved issues
│   │   ├── resolved-issues/           # Completed resolutions
│   │   ├── methodology-decisions/     # Framework approach decisions
│   │   └── framework-specific/        # Technology-specific solutions
├── progress/
│   ├── blockers/                      # Timeline impact documentation
│   ├── context-preservation/          # Session handoff documentation
│   └── decision-logs/                 # Technical decision history
└── knowledge/
    ├── lessons-learned/               # Cross-project insights
    ├── prevention-strategies/         # Proactive problem avoidance
    └── framework-patterns/            # Technology-specific patterns
```

### Naming Conventions

- **Blockers**: `YYYY-MM-DD_blocker_[component]_[issue-type]_[framework].md`
- **Context**: `YYYY-MM-DD_context_[session]_[methodology]_[framework].md`
- **Lessons**: `YYYY-MM-DD_lesson_[category]_[solution-type]_[framework].md`
- **Decisions**: `YYYY-MM-DD_decision_[choice]_[methodology]_[rationale].md`

## Core Templates

### 1. Blocker Analysis Template

```markdown
# Blocker Analysis: [Component/Feature Name]

**Date**: [YYYY-MM-DD]  
**Framework**: [React/Vue/Angular/Vanilla]  
**Methodology**: [MVP/Balanced/Enterprise]  
**Time Invested**: [X] minutes  
**Timeline Impact**: [X]% of remaining schedule

## Problem Statement
**Issue**: [Clear description of the problem]
**Framework Context**: [Version, build tool, specific integrations]
**Reproduction Steps**:
1. [Step 1 with exact commands/actions]
2. [Step 2 with file paths and line numbers]
3. [Step 3 with expected vs actual behavior]

## Attempted Solutions
| Time | Approach | Framework-Specific Details | Result |
|------|----------|---------------------------|--------|
| [X min] | [Solution 1] | [Framework version/config] | [Failed/Partial] |
| [X min] | [Solution 2] | [Dependencies/tools used] | [Failed/Partial] |

## Impact Assessment
- **Components Affected**: [List with file paths]
- **Features Impacted**: [User-facing functionality]
- **Timeline Risk**: [Days behind schedule]
- **Framework Constraints**: [Version/compatibility issues]

## Root Cause Hypothesis
**Primary Theory**: [Most likely cause with evidence]
**Framework Factors**: [Technology-specific considerations]
**Design System Impact**: [CSS Modules/token conflicts]

## Recommended Next Actions
1. **[Action 1]** - [Time estimate] - [Framework-specific approach]
2. **[Action 2]** - [Time estimate] - [Alternative framework solution]
3. **[Action 3]** - [Time estimate] - [Escalation if needed]

## Escalation Criteria
- [ ] Time threshold exceeded for methodology
- [ ] Multiple components affected
- [ ] Framework expertise required beyond team capability
- [ ] Security or compliance implications
```

### 2. Context Preservation Template

```markdown
# Development Context: [Session Name]

**Date**: [YYYY-MM-DD]  
**Framework**: [React/Vue/Angular/Vanilla]  
**Methodology**: [MVP/Balanced/Enterprise]  
**Session Duration**: [X] hours

## Current Implementation State
**Active Files**:
- `[file-path]` - Line [X]: [Current state description]
- `[file-path]` - Line [X]: [Current state description]

**Framework Configuration**:
- **Version**: [Framework version]
- **Build Tool**: [Webpack/Vite/CLI version]
- **Key Dependencies**: [CSS Modules loader, design system packages]

**Git State**:
- **Branch**: [current-branch-name]
- **Last Commit**: [commit-hash] - [commit-message]
- **Uncommitted Changes**: [List of modified files]

## Decision Rationale
**Key Choices Made**:
1. **[Decision 1]**: [Rationale with methodology alignment]
2. **[Decision 2]**: [Framework-specific considerations]
3. **[Decision 3]**: [Design system implications]

## Mental Model
**Problem Understanding**: [2-3 sentence summary]
**Component Relationships**: [How pieces connect]
**Data Flow**: [State/props/styling flow]
**Framework Integration Points**: [Specific technology touchpoints]

## Resumption Instructions
**Next 3 Actions**:
1. **[Action 1]** - [Estimated time] - [Specific framework commands]
2. **[Action 2]** - [Estimated time] - [File locations and changes needed]
3. **[Action 3]** - [Estimated time] - [Validation steps]

**Development Environment**:
- **Running Processes**: [Dev server, build watchers]
- **Open Terminals**: [Commands in progress]
- **IDE State**: [Open files, breakpoints, configurations]

## Related Documentation
- **Reference Docs**: [Links to methodology docs]
- **Framework Resources**: [Specific guides/documentation]
- **Design System Docs**: [Token/component documentation]

## AI Assistant Context
**Key Conversation Points**:
- [Technical decisions discussed]
- [Framework-specific guidance received]
- [Design system recommendations]
```

### 3. Learning Capture Template

```markdown
# Learning Capture: [Problem Category]

**Date**: [YYYY-MM-DD]
**Framework**: [React/Vue/Angular/Vanilla]
**Methodology**: [MVP/Balanced/Enterprise]
**Problem Category**: [CSS Modules/Design System/Framework Integration]

## Problem Summary
**Issue**: [Brief description with methodology context]
**Framework Context**: [Version, tools, specific integrations]
**Time Invested**: [Total time from start to resolution]

## Successful Solution
**Approach**: [What worked with implementation details]
**Framework-Specific Steps**:
1. [Step 1 with exact commands/configuration]
2. [Step 2 with code examples]
3. [Step 3 with validation methods]

**Code Examples**:
```[language]
// [Framework-specific implementation]
[actual working code]
```

## Failed Approaches
| Approach | Framework Limitations | Time Spent | Failure Reason |
|----------|----------------------|------------|----------------|
| [Approach 1] | [Version/compatibility issues] | [X min] | [Specific reason] |
| [Approach 2] | [Tool/build limitations] | [X min] | [Specific reason] |

## Alternative Strategies
**For Future Use**:
1. **[Strategy 1]**: [When to use] - [Framework applicability]
2. **[Strategy 2]**: [When to use] - [Cross-framework potential]

## Knowledge Gained
**Applicable to Other Projects**:
- [Insight 1 with framework transferability]
- [Insight 2 with design system implications]
- [Insight 3 with methodology considerations]

## Prevention Strategies
**Implementation Guidance**:
1. **[Prevention 1]**: [How to implement] - [Framework-specific setup]
2. **[Prevention 2]**: [How to implement] - [Universal applicability]

**Framework-Specific Considerations**:
- [Framework limitation or advantage]
- [Version-specific behavior]
- [Integration best practices]
```

### 4. Decision Log Template

```markdown
# Decision Log: [Decision Made]

**Date**: [YYYY-MM-DD]
**Framework**: [React/Vue/Angular/Vanilla]
**Methodology**: [MVP/Balanced/Enterprise]
**Decision Type**: [Architecture/Implementation/Framework Choice]

## Decision Made
**Statement**: [Clear decision with specific choice]
**Alternatives Considered**:
1. [Alternative 1] - [Brief description]
2. [Alternative 2] - [Brief description]
3. [Alternative 3] - [Brief description]

## Context
**Methodology Constraints**: [Timeline/scope/quality requirements]
**Framework Factors**: [Version/capability/ecosystem considerations]
**Team Capabilities**: [Expertise level/availability/learning curve]

## Rationale
**Supporting Evidence**:
- [Evidence 1 with data/benchmarks]
- [Evidence 2 with framework-specific benefits]
- [Evidence 3 with methodology alignment]

**Trade-off Analysis**:
| Factor | Chosen Approach | Alternative | Impact |
|--------|----------------|-------------|--------|
| [Factor 1] | [Pro/Con] | [Pro/Con] | [High/Med/Low] |
| [Factor 2] | [Pro/Con] | [Pro/Con] | [High/Med/Low] |

## Implementation Approach
**Specific Steps**:
1. [Step 1 with framework commands/configuration]
2. [Step 2 with file changes and validation]
3. [Step 3 with testing and deployment]

**Validation Criteria**:
- [ ] [Criterion 1 with measurable outcome]
- [ ] [Criterion 2 with framework-specific validation]
- [ ] [Criterion 3 with design system compliance]

## Rollback Plan
**If Decision Proves Incorrect**:
1. [Rollback step 1 with specific actions]
2. [Rollback step 2 with framework considerations]
3. [Rollback step 3 with timeline impact]

## Lessons Learned
**Applicability to Future Decisions**:
- [Lesson 1 with framework transferability]
- [Lesson 2 with methodology considerations]
- [Lesson 3 with design system implications]
```

## Methodology-Aware Decision Matrices

### MVP/Rapid Decision Matrix (2-4 week timeline)

**Continue Criteria** (All must be true):
- [ ] <30 minutes invested in current approach
- [ ] Solution path clearly identified and documented
- [ ] No impact on core user workflow functionality
- [ ] Framework supports approach with existing team knowledge
- [ ] Quick win potential with minimal technical debt

**Pivot Criteria** (Any can trigger):
- [ ] Scope reduction possible (20%+ feature reduction)
- [ ] Alternative saves >4 hours of development time
- [ ] Maintains core functionality with simpler implementation
- [ ] Framework-compatible workaround available
- [ ] Technical debt acceptable for MVP timeline

**Restart Criteria** (Any can trigger):
- [ ] Fundamental approach flawed beyond quick fixes
- [ ] Affects core user workflow or critical features
- [ ] No viable workaround within framework constraints
- [ ] Framework limitations confirmed by documentation/community

**Escalation Criteria** (Any can trigger):
- [ ] Timeline impact >1 day (>12.5% of 2-week sprint)
- [ ] Affects multiple core features simultaneously
- [ ] Requires framework expertise outside team capability
- [ ] Security or data integrity implications

### Balanced/Standard Decision Matrix (4-8 week timeline)

**Continue Criteria** (All must be true):
- [ ] Solution path identified within 60 minutes
- [ ] Quality standards maintainable with current approach
- [ ] Framework best practices can be followed
- [ ] Learning value justifies time investment
- [ ] Aligns with design system architecture

**Pivot Criteria** (Any can trigger):
- [ ] Alternative approach saves >2 days development time
- [ ] Significantly improves long-term maintainability
- [ ] Team can execute with current skill set
- [ ] Framework supports better solution pattern
- [ ] Reduces technical debt or complexity

**Restart Criteria** (Any can trigger):
- [ ] Current approach creates technical debt >20% of remaining timeline
- [ ] Violates established framework conventions or patterns
- [ ] Conflicts with design system architecture principles
- [ ] Performance implications unacceptable for production

**Escalation Criteria** (Any can trigger):
- [ ] Affects 3+ components or system-wide architecture
- [ ] Requires expertise outside current team capability
- [ ] Framework limitations block progress on core features
- [ ] Timeline impact >2 days (>6.25% of 4-week phase)

### Comprehensive/Enterprise Decision Matrix (8-12 week timeline)

**Continue Criteria** (All must be true):
- [ ] High learning value for team and organization
- [ ] Architectural soundness maintained throughout
- [ ] <90 minutes invested with clear progress
- [ ] Solution aligns with enterprise framework standards
- [ ] Scalability and maintainability preserved

**Pivot Criteria** (Any can trigger):
- [ ] Better long-term solution exists with proven benefits
- [ ] Improves system scalability or performance significantly
- [ ] Timeline permits thorough implementation
- [ ] Framework roadmap supports approach long-term
- [ ] Reduces operational complexity or maintenance burden

**Restart Criteria** (Any can trigger):
- [ ] Violates enterprise architecture principles
- [ ] Framework security requirements cannot be met
- [ ] Compliance or audit requirements compromised
- [ ] Fundamental design system principles violated

**Escalation Criteria** (Any can trigger):
- [ ] Affects system architecture or cross-team dependencies
- [ ] Requires security review or compliance validation
- [ ] Impacts other teams or shared infrastructure
- [ ] Framework upgrade or migration required

### Universal Decision Criteria (All Methodologies)

**Time Investment Assessment**:
- Calculate percentage of remaining methodology timeline
- Include framework learning curve in estimates
- Consider context switching costs and ramp-up time
- Factor in documentation and knowledge transfer time

**Problem Complexity vs Team Expertise**:
- Map problem to team's framework-specific skill matrix
- Identify knowledge gaps and learning requirements
- Assess availability of framework community support
- Consider long-term team capability development

**Impact Radius Analysis**:
- Count affected components, features, and integrations
- Assess framework-specific ripple effects
- Evaluate design system consistency implications
- Consider cross-browser and device compatibility

**Framework Alignment Check**:
- Verify approach follows framework best practices
- Confirm compatibility with current and future versions
- Assess integration with existing build and deployment pipeline
- Validate against framework security and performance guidelines

## Solo Development and AI Assistant Continuity Protocols

### Session Handoff Protocol (Required Format)

**Before Every Break or Context Switch:**

```markdown
## Session Handoff: [YYYY-MM-DD HH:MM]

### Current Mental Model
**Problem Understanding**: [2-3 sentences with framework context]
**Implementation State**: [What's working, what's not, current approach]
**Framework Context**: [Version, build state, key configurations]

### Key Implementation Decisions
1. **[Decision 1]**: [Rationale with methodology alignment]
2. **[Decision 2]**: [Framework-specific considerations]
3. **[Decision 3]**: [Design system implications]

### Code State Snapshot
**Modified Files**:
- `[file-path]:[line-range]` - [Current state and next changes needed]
- `[file-path]:[line-range]` - [Current state and next changes needed]

**Framework Configuration**:
- **Package.json changes**: [Dependencies added/modified]
- **Build config**: [Webpack/Vite/CLI modifications]
- **Environment variables**: [New or modified env vars]

### Next Planned Actions
1. **[Action 1]** - [Time estimate] - [Specific framework commands]
2. **[Action 2]** - [Time estimate] - [File changes and validation steps]
3. **[Action 3]** - [Time estimate] - [Testing and integration steps]

### AI Assistant Context
**Technical Decisions Discussed**:
- [Key conversation points with reasoning]
- [Framework-specific guidance received]
- [Design system recommendations and rationale]

**Current Understanding Level**:
- [What AI assistant knows about current implementation]
- [Framework-specific context provided]
- [Design system decisions and constraints discussed]
```

### Task Switching Checklist (Mandatory)

**Before Switching Tasks or Taking Breaks:**
- [ ] **Progress Documentation**: Current state documented with file locations and framework version
- [ ] **Decision Recording**: Rationale recorded with methodology alignment and framework constraints
- [ ] **Configuration Preservation**: Package.json, build configs, environment variables documented
- [ ] **Resumption Instructions**: Exact next steps written with framework-specific commands
- [ ] **Reference Documentation**: Related docs updated or linked with framework-specific sections
- [ ] **Git State Management**: Descriptive commit with framework context or WIP branch created
- [ ] **Environment Documentation**: Running processes, terminals, IDE state recorded

**Framework-Specific Checklist Items:**

**React Projects**:
- [ ] Component state and props documented
- [ ] Hook dependencies and effects noted
- [ ] Build warnings or errors recorded
- [ ] Next.js/CRA specific configurations preserved

**Vue Projects**:
- [ ] Component composition and reactivity documented
- [ ] Nuxt.js or Vue CLI configurations noted
- [ ] Single File Component state recorded
- [ ] Build tool specific settings preserved

**Angular Projects**:
- [ ] Component lifecycle and services documented
- [ ] Angular CLI configurations noted
- [ ] Dependency injection state recorded
- [ ] Module and routing changes preserved

**Vanilla JavaScript Projects**:
- [ ] Module system and bundling approach documented
- [ ] Build tool configurations preserved
- [ ] Browser compatibility requirements noted
- [ ] Polyfill and feature detection state recorded

### AI Assistant Context Preservation Strategies

**Conversation Summary Template**:
```markdown
## AI Assistant Context Summary

### Technical Decisions Made
**Framework Choices**:
- [Choice 1]: [Reasoning with methodology considerations]
- [Choice 2]: [Framework-specific benefits and limitations]
- [Choice 3]: [Design system integration implications]

### Code Context Provided
**Component Relationships**:
- [Component A] → [Component B]: [Data flow and styling dependencies]
- [Component C] ↔ [Component D]: [Bidirectional interactions]

**Framework Integration Points**:
- [Integration 1]: [How framework handles CSS Modules]
- [Integration 2]: [Build tool and bundling approach]
- [Integration 3]: [Development server and hot reload setup]

### Design System Understanding
**Token Usage Patterns**:
- [Pattern 1]: [How design tokens are consumed in framework]
- [Pattern 2]: [Component styling conventions established]
- [Pattern 3]: [Responsive design implementation approach]

### Current Problem Context
**Issue Understanding**: [AI's current understanding of the problem]
**Solution Approaches Discussed**: [Approaches considered with pros/cons]
**Framework Constraints Identified**: [Limitations and workarounds discussed]
```

**Context Resumption Protocol**:
1. **Load Previous Context**: Review session handoff and AI context summary
2. **Validate Understanding**: Confirm current state matches documented state
3. **Framework State Check**: Verify build tools, dependencies, and configurations
4. **Problem Reorientation**: Re-establish problem context and solution approach
5. **Next Action Confirmation**: Validate planned next steps are still appropriate

## CSS Modules and Design System Specific Troubleshooting

### CSS Modules Common Issues (Framework-Independent)

#### Class Name Conflicts
**Symptoms**: Styles not applying, unexpected visual behavior, TypeScript errors
**Framework-Agnostic Diagnosis**:
1. Check CSS Module file naming (must include `.module.css`)
2. Verify import statement syntax for framework
3. Confirm class name usage matches exported names
4. Validate build tool CSS Module configuration

**Resolution by Methodology**:
- **MVP/Rapid**: Use framework defaults, avoid custom configurations
- **Balanced/Standard**: Implement proper naming conventions and TypeScript integration
- **Comprehensive/Enterprise**: Full type generation and linting integration

**Framework-Specific Solutions**:
```javascript
// React/Next.js
import styles from './Component.module.css';
<div className={styles.componentName} />

// Vue.js
<template>
  <div :class="$style.componentName" />
</template>
<style module>
.componentName { }
</style>

// Angular
@Component({
  styleUrls: ['./component.component.css']
})
// Use ViewEncapsulation.None for global styles
```

#### Build Configuration Issues
**Symptoms**: CSS not loading, build errors, hot reload failures
**Universal Diagnosis Steps**:
1. Verify CSS Module loader configuration
2. Check framework-specific build tool setup
3. Validate file extensions and naming patterns
4. Confirm development vs production build differences

**Framework-Specific Configurations**:
```javascript
// Webpack (React/Vue)
{
  test: /\.module\.css$/,
  use: [
    'style-loader',
    {
      loader: 'css-loader',
      options: {
        modules: {
          localIdentName: '[name]__[local]___[hash:base64:5]'
        }
      }
    }
  ]
}

// Vite (Vue/React)
export default {
  css: {
    modules: {
      localsConvention: 'camelCase'
    }
  }
}

// Angular CLI
// Use component-level encapsulation by default
@Component({
  encapsulation: ViewEncapsulation.Emulated
})
```

### Design System Challenges (Universal)

#### Token Conflicts
**Symptoms**: Inconsistent spacing/colors, CSS custom property inheritance issues
**Diagnosis Framework**:
1. **Specificity Analysis**: Check CSS cascade and inheritance
2. **Token Scope**: Verify `:root` vs component-level token definitions
3. **Framework Integration**: Confirm how framework handles CSS custom properties
4. **Responsive Behavior**: Validate token application across breakpoints

**Resolution Patterns**:
```css
/* Universal Token Structure */
:root {
  /* Base tokens */
  --color-primary-500: #3b82f6;
  --spacing-md: 1rem;
}

/* Component-specific overrides */
.component {
  --local-spacing: var(--spacing-md);
  padding: var(--local-spacing);
}

/* Framework-specific token consumption */
/* React: Direct CSS custom property usage */
/* Vue: CSS custom properties in scoped styles */
/* Angular: CSS custom properties with ViewEncapsulation */
```

#### Component API Inconsistencies
**Symptoms**: Props not working as expected, styling conflicts between components
**Framework-Agnostic Analysis**:
1. **Interface Consistency**: Verify prop naming conventions across components
2. **Style Composition**: Check how framework handles style merging
3. **Default Values**: Confirm framework-specific default prop handling
4. **Type Safety**: Validate TypeScript integration for style props

**Methodology-Specific Approaches**:
- **MVP/Rapid**: Simple prop interfaces, minimal customization
- **Balanced/Standard**: Structured prop system with common patterns
- **Comprehensive/Enterprise**: Full type safety and composition patterns

### Framework-Specific Integration Guidance

#### React-Specific Considerations
**CSS Modules Integration**:
- Component lifecycle and style application timing
- Hooks and dynamic styling state management
- SSR/Next.js hydration and style loading
- Performance optimization with React.memo and style dependencies

**Common Issues**:
```javascript
// Problem: Dynamic class names not working
const dynamicClass = isActive ? styles.active : styles.inactive;

// Solution: Proper conditional class application
const className = `${styles.base} ${isActive ? styles.active : styles.inactive}`;

// Advanced: Using clsx for complex conditions
import clsx from 'clsx';
const className = clsx(styles.base, {
  [styles.active]: isActive,
  [styles.disabled]: isDisabled
});
```

#### Vue-Specific Considerations
**Single File Component Integration**:
- Scoped styles vs CSS Modules choice
- Nuxt.js configuration and SSR considerations
- Reactive styling with computed properties
- Component composition and style inheritance

**Common Patterns**:
```vue
<template>
  <div :class="componentClasses">
    Content
  </div>
</template>

<script>
export default {
  computed: {
    componentClasses() {
      return {
        [this.$style.base]: true,
        [this.$style.active]: this.isActive
      };
    }
  }
}
</script>

<style module>
.base { }
.active { }
</style>
```

#### Angular-Specific Considerations
**Component Encapsulation**:
- ViewEncapsulation strategies and CSS Modules
- Angular CLI configuration for CSS preprocessing
- Dependency injection and styling services
- Component communication and shared styles

**Integration Patterns**:
```typescript
@Component({
  selector: 'app-component',
  templateUrl: './component.component.html',
  styleUrls: ['./component.component.css'],
  encapsulation: ViewEncapsulation.Emulated
})
export class ComponentComponent {
  @HostBinding('class') get cssClass() {
    return 'component-base';
  }
}
```

#### Vanilla JavaScript Considerations
**Module System Integration**:
- ES6 modules and CSS Module loading
- Build tool configuration (Webpack, Rollup, Parcel)
- Browser compatibility and polyfill requirements
- Performance optimization without framework abstractions

**Implementation Approach**:
```javascript
// CSS Module import in vanilla JS
import styles from './component.module.css';

// Manual class application
function createComponent(element, props) {
  element.className = `${styles.base} ${props.variant ? styles[props.variant] : ''}`;
}

// Dynamic style updates
function updateComponentState(element, isActive) {
  element.classList.toggle(styles.active, isActive);
}
```

## Realistic Scenario Examples

### Scenario 1: CSS Module Class Names Not Applying (React/MVP)

**Problem**: Button component styles not rendering, TypeScript errors on class names
**Timeline**: Day 2 of 2-week MVP sprint
**Framework**: React 18 with Next.js 14

**15-Minute Assessment**:
```markdown
**Issue**: `styles.primaryButton` undefined, component renders unstyled
**Quick Checks**:
- [ ] File named `Button.module.css` ✓
- [ ] Import statement: `import styles from './Button.module.css'` ✓
- [ ] Class exists in CSS file ✓
- [ ] Next.js CSS Module support enabled ✓

**Problem Found**: Class name is `primary-button` in CSS but accessing as `primaryButton`
```

**Resolution (MVP Approach)**:
```javascript
// Quick Fix: Match CSS class name exactly
<button className={styles['primary-button']}>

// Or rename CSS class to camelCase
.primaryButton { /* styles */ }
```

**Time Invested**: 12 minutes
**Decision**: Continue with quick fix, document naming convention for team

### Scenario 2: Design Token Inheritance Conflict (Vue/Balanced)

**Problem**: Component tokens overriding global design system values
**Timeline**: Week 3 of 6-week balanced implementation
**Framework**: Vue 3 with Nuxt.js

**30-Minute Investigation**:
```markdown
**Issue**: Card component spacing inconsistent across pages
**Root Cause**: Component-scoped CSS custom properties overriding global tokens
**Framework Factor**: Vue scoped styles creating specificity conflicts

**Attempted Solutions**:
1. `!important` declarations (5 min) - Failed: Creates maintenance issues
2. Increased specificity (10 min) - Failed: Breaks design system principles
3. CSS Module approach (15 min) - Success: Proper scoping without conflicts
```

**Resolution (Balanced Approach)**:
```vue
<template>
  <div :class="$style.card">
    <slot />
  </div>
</template>

<style module>
.card {
  padding: var(--spacing-lg);
  /* Uses global design tokens without conflicts */
}
</style>
```

**Time Invested**: 28 minutes
**Decision**: Migrate component to CSS Modules, update team guidelines

### Scenario 3: Build Configuration Breaking Production (Angular/Enterprise)

**Problem**: CSS Modules working in development but failing in production build
**Timeline**: Week 8 of 12-week enterprise implementation
**Framework**: Angular 16 with custom webpack configuration

**60-Minute Deep Investigation**:
```markdown
**Issue**: Production build strips CSS Module class names
**Framework Context**: Angular CLI webpack customization conflicts
**Impact**: All component styling broken in production

**Investigation Steps**:
1. Development vs production webpack diff analysis (20 min)
2. Angular CLI CSS processing pipeline review (20 min)
3. CSS Module loader configuration validation (20 min)

**Root Cause**: Production optimization removing "unused" CSS classes
```

**Resolution (Enterprise Approach)**:
```javascript
// Custom webpack configuration
const ModuleFederationPlugin = require('@angular-architects/module-federation/webpack');

module.exports = {
  optimization: {
    usedExports: false, // Prevent CSS Module class removal
  },
  module: {
    rules: [
      {
        test: /\.module\.css$/,
        use: [
          {
            loader: 'css-loader',
            options: {
              modules: {
                localIdentName: '[name]__[local]___[hash:base64:5]',
                exportOnlyLocals: false
              }
            }
          }
        ]
      }
    ]
  }
};
```

**Time Invested**: 58 minutes
**Decision**: Continue with thorough solution, document for other teams

### Scenario 4: Responsive Design Token Conflicts (Vanilla JS/MVP)

**Problem**: Design tokens not responding correctly across breakpoints
**Timeline**: Day 6 of 3-week MVP implementation
**Framework**: Vanilla JavaScript with Vite

**45-Minute Analysis** (Approaching MVP escalation threshold):
```markdown
**Issue**: Mobile spacing tokens not applying below 768px
**Framework Context**: No framework abstraction for responsive token management
**Complexity**: Manual media query management required

**Time Pressure**: MVP deadline in 9 days, affects core mobile experience
```

**Resolution (MVP Pivot)**:
```css
/* Simplified approach for MVP */
.component {
  padding: var(--spacing-md);
}

@media (max-width: 767px) {
  .component {
    padding: var(--spacing-sm);
  }
}

/* Document for future enhancement */
/* TODO: Implement responsive token system in post-MVP phase */
```

**Time Invested**: 43 minutes
**Decision**: Pivot to manual media queries, scope responsive token system for future

### Scenario 5: Framework Migration Breaking CSS Modules (React to Vue/Balanced)

**Problem**: Migrating component library from React to Vue, CSS Modules not transferring
**Timeline**: Week 5 of 7-week balanced migration
**Framework**: Vue 3 (migrating from React 18)

**90-Minute Extended Investigation** (Balanced methodology permits):
```markdown
**Issue**: React CSS Module patterns incompatible with Vue SFC approach
**Complexity**: 15+ components need migration strategy
**Framework Differences**: Different CSS Module integration approaches

**Migration Strategy Required**: Systematic approach for remaining components
```

**Resolution (Balanced Approach)**:
```javascript
// Migration utility for CSS Module class conversion
function convertReactToVueClasses(reactStyles) {
  return Object.keys(reactStyles).reduce((acc, key) => {
    acc[key] = reactStyles[key];
    return acc;
  }, {});
}

// Vue component template
<template>
  <div :class="componentClasses">
    <slot />
  </div>
</template>

<script>
import styles from './Component.module.css';

export default {
  computed: {
    componentClasses() {
      return {
        [styles.base]: true,
        [styles.variant]: this.variant
      };
    }
  }
}
</script>
```

**Time Invested**: 87 minutes
**Decision**: Continue with systematic migration, create reusable patterns

## Integration with Reference Documentation

### Linking to Methodology Documentation

**When Creating Blocker Analysis**:
- Reference appropriate methodology documentation from `docs/sandbox/[phase-number]-[phase-folder]/`
- Link to specific methodology approach being followed (01-, 02-, or 03-)
- Include methodology-specific constraints and success criteria

**Documentation Cross-References**:
```markdown
## Related Reference Documentation
- **Foundation**: `docs/sandbox/02-component-system/00-component-system-foundation.md`
- **Current Methodology**: `docs/sandbox/02-component-system/01-rapid-mvp-methodology.md`
- **Alternative Approaches**:
  - `docs/sandbox/02-component-system/02-balanced-standard-methodology.md`
  - `docs/sandbox/02-component-system/03-comprehensive-enterprise-methodology.md`

## Methodology Alignment Check
- [ ] Problem resolution aligns with chosen methodology timeline
- [ ] Solution complexity appropriate for methodology scope
- [ ] Quality standards met for methodology requirements
- [ ] Documentation updated in methodology-specific files
```

### Milestone Validation Integration

**Troubleshooting Impact on Milestones**:
```markdown
## Milestone Impact Assessment

### Current Milestone: [Milestone Name from Roadmap]
**Target Date**: [Date from methodology roadmap]
**Completion Status**: [Percentage] complete
**Blocker Impact**: [Days] delay potential

### Validation Criteria Affected
- [ ] [Criterion 1]: [Impact description]
- [ ] [Criterion 2]: [Impact description]
- [ ] [Criterion 3]: [Impact description]

### Adjustment Recommendations
**Scope Adjustments**: [Specific features to defer/modify]
**Timeline Adjustments**: [Realistic completion estimate]
**Quality Trade-offs**: [Acceptable compromises for methodology]
```

### Progress Tracking Template Integration

**Weekly Status Report Updates**:
```markdown
## Troubleshooting Impact on Progress

### Blockers Resolved This Week
- [Blocker 1]: [Resolution summary] - [Time saved/lost]
- [Blocker 2]: [Resolution summary] - [Time saved/lost]

### Active Blockers
- [Active Blocker 1]: [Current status] - [Escalation timeline]
- [Active Blocker 2]: [Current status] - [Escalation timeline]

### Lessons Applied
- [Lesson 1]: [How it prevented/resolved issues this week]
- [Lesson 2]: [How it improved development velocity]

### Prevention Strategies Implemented
- [Strategy 1]: [Implementation details] - [Effectiveness measure]
- [Strategy 2]: [Implementation details] - [Effectiveness measure]
```

## Success Criteria and Validation

### Protocol Effectiveness Metrics

**Problem Resolution Time Targets**:
- **15-minute assessment**: 95% of syntax/import issues resolved
- **30-minute investigation**: 80% of component/design issues resolved
- **60-minute escalation**: 90% of complex issues have clear resolution path
- **Framework learning curve**: <20% additional time for new framework adoption

**Context Preservation Success**:
- **Resumption time**: <5 minutes to re-orient after interruption
- **Knowledge transfer**: 90% of context preserved across sessions
- **AI assistant continuity**: <3 exchanges to restore full context
- **Cross-framework transfer**: <30% additional setup time for framework migration

**Methodology Timeline Adherence**:
- **MVP/Rapid**: 95% of issues resolved within methodology time thresholds
- **Balanced/Standard**: 90% of decisions align with quality/timeline balance
- **Comprehensive/Enterprise**: 85% of solutions meet enterprise architecture standards

### Validation Checklist

**Protocol Implementation**:
- [ ] All four core templates available and customized for project
- [ ] Folder structure created with framework-specific sections
- [ ] Decision matrices printed/bookmarked for quick reference
- [ ] Team trained on methodology-specific escalation criteria
- [ ] AI assistant context preservation templates ready

**Framework Integration**:
- [ ] Framework-specific troubleshooting sections reviewed
- [ ] Build tool configurations documented and validated
- [ ] CSS Module integration patterns established
- [ ] Design system token usage patterns confirmed

**Documentation Integration**:
- [ ] Links to Reference Documentation structure established
- [ ] Milestone validation templates integrated
- [ ] Progress tracking templates customized
- [ ] Cross-references to methodology documents created

## Framework-Specific Quick Reference

### React/Next.js Quick Fixes
```javascript
// CSS Module import issues
import styles from './Component.module.css'; // Correct
import './Component.module.css'; // Incorrect

// Dynamic class names
const className = `${styles.base} ${isActive ? styles.active : ''}`;

// TypeScript integration
declare module '*.module.css' {
  const classes: { [key: string]: string };
  export default classes;
}

// Next.js configuration
// next.config.js
module.exports = {
  experimental: {
    cssModules: true
  }
}
```

### Vue/Nuxt.js Quick Fixes
```vue
<!-- CSS Module usage in SFC -->
<template>
  <div :class="$style.component">
    Content
  </div>
</template>

<style module>
.component {
  /* styles */
}
</style>

<!-- Nuxt.js configuration -->
<!-- nuxt.config.js -->
export default {
  css: {
    modules: {
      localsConvention: 'camelCase'
    }
  }
}
```

### Angular Quick Fixes
```typescript
// Component with CSS Modules
@Component({
  selector: 'app-component',
  templateUrl: './component.component.html',
  styleUrls: ['./component.component.css'],
  encapsulation: ViewEncapsulation.None // For CSS Modules
})

// Angular CLI configuration
// angular.json
"styles": [
  {
    "input": "src/styles/global.css",
    "bundleName": "global"
  }
]
```

### Vanilla JavaScript Quick Fixes
```javascript
// CSS Module import with build tools
import styles from './component.module.css';

// Manual class application
function applyStyles(element, styleClasses) {
  element.className = Object.keys(styleClasses)
    .filter(key => styleClasses[key])
    .map(key => styles[key])
    .join(' ');
}

// Vite configuration
// vite.config.js
export default {
  css: {
    modules: {
      localsConvention: 'camelCase',
      generateScopedName: '[name]__[local]___[hash:base64:5]'
    }
  }
}
```

## Protocol Maintenance and Updates

### Regular Review Schedule
- **Weekly**: Review active blockers and resolution effectiveness
- **Monthly**: Update framework-specific sections based on new versions
- **Quarterly**: Analyze success metrics and adjust time thresholds
- **Per Project**: Capture lessons learned and update prevention strategies

### Continuous Improvement Process
1. **Collect Metrics**: Track resolution times and success rates
2. **Identify Patterns**: Common issues and effective solutions
3. **Update Templates**: Improve based on real-world usage
4. **Share Knowledge**: Cross-project learning and best practices
5. **Framework Updates**: Adapt to new framework versions and patterns

### Version Control for Protocol
- **Document Version**: Track protocol updates and improvements
- **Framework Compatibility**: Maintain compatibility matrices
- **Template Evolution**: Version control for template improvements
- **Success Metrics**: Historical tracking of effectiveness improvements

## Integration with Enhanced Documentation Systems

### 🔧 Feature Development Integration
- [Feature Development Best Practices](../project-lifecycle/feature-development/README.md) - Apply troubleshooting protocols within feature development workflows
- [Feature Planning Template](../project-lifecycle/feature-development/feature-planning-template.md) - Include troubleshooting considerations in feature planning
- [Feature Completion Checklist](../project-lifecycle/feature-development/feature-completion-checklist.md) - Validate troubleshooting documentation as part of feature completion

### 📋 Project Lifecycle Integration
- [Project Lifecycle Framework](../project-lifecycle/README.md) - Phase-specific troubleshooting strategies and escalation procedures
- [Phase 4: Core Development](../project-lifecycle/04-core-development/README.md) - Development-phase troubleshooting integration
- [Decision Trees](../project-lifecycle/decision-trees/) - Structured decision-making for troubleshooting scenarios

### 🛠️ Git Workflow Integration
- [Git Workflow and Policies](../project-lifecycle/git-workflow/README.md) - Version control troubleshooting and recovery procedures
- [Git Conflict Resolution Guide](./GIT_CONFLICT_RESOLUTION_GUIDE.md) - Specialized Git troubleshooting strategies
- [Git Branches and Deployment Strategy](./GIT_BRANCHES_AND_DEPLOYMENT_STRATEGY.md) - Deployment troubleshooting workflows

### 🎯 Development Workflow Integration
- [Solo Development Best Practices](./SOLO_DEVELOPMENT_BEST_PRACTICES.md) - Individual developer troubleshooting workflows
- [Core Application Features](../core-features/README.md) - Feature-specific troubleshooting patterns
- [Development Troubleshooting Directory](./troubleshooting/README.md) - Centralized troubleshooting documentation system

---

**End of Protocol**

*This troubleshooting protocol is designed to be framework-agnostic and methodology-aware, providing structured guidance for CSS Modules and design system development challenges while maintaining project momentum and preserving development context. It now integrates seamlessly with the enhanced documentation systems for comprehensive development support.*
