# Development Session Recovery Process

**Version**: 1.0  
**Created**: July 2025  
**Purpose**: Framework-agnostic recovery process for derailed App Development development sessions  
**Integration**: Works with Troubleshooting Protocol and three-methodology framework

## 🚨 IMMEDIATE TRIAGE PROTOCOL (0-5 Minutes)

### Quick Assessment Checklist

**Step 1: Identify Derailment Type** (30 seconds)
- [ ] **Technical Blocker**: Code/build/framework issue preventing progress
- [ ] **Context Loss**: Interruption/task switch causing mental model loss
- [ ] **Scope Creep**: Requirements/features expanding beyond methodology limits
- [ ] **Environment Failure**: Build tools/dependencies/configuration broken
- [ ] **Design System Conflict**: Architecture/token/component conflicts
- [ ] **Capacity Change**: Team member unavailable/knowledge gap identified

**Step 2: Emergency Stabilization** (2 minutes)
```bash
# Universal Stabilization Commands (Framework-Agnostic)
git status                    # Check uncommitted changes
git stash push -m "emergency-backup-$(date +%Y%m%d-%H%M)"
git log --oneline -5         # Recent commit history
npm list --depth=0          # Dependency state (or yarn list)
```

**Step 3: Methodology Impact Assessment** (2 minutes)
| Methodology | Timeline Impact Threshold | Quality Impact Threshold | Scope Impact Threshold |
|-------------|--------------------------|-------------------------|------------------------|
| **MVP/Rapid** | >4 hours (>12.5% of week) | Core features affected | >20% feature reduction |
| **Balanced/Standard** | >1 day (>12.5% of phase) | User experience degraded | >15% scope change |
| **Comprehensive/Enterprise** | >2 days (>8% of phase) | Architecture compromised | >10% scope expansion |

**Step 4: Framework State Preservation** (30 seconds)
```markdown
## Emergency State Snapshot - [TIMESTAMP]
**Framework**: [React/Vue/Angular/Vanilla]
**Last Working State**: [Commit hash or description]
**Current Issue**: [One sentence problem description]
**Environment**: [Node version, package manager, build tool]
**Immediate Risk**: [Data loss/timeline/quality concern]
```

## 🔄 RECOVERY DECISION MATRIX

### Decision Tree (Use First Applicable)

```
Derailment Detected
├── Can identify last working state? 
│   ├── YES → Context Reconstruction Process
│   └── NO → Session Restart Protocol
├── Is environment functional?
│   ├── YES → Continue with current approach
│   └── NO → Environment Recovery Process
├── Is timeline severely impacted?
│   ├── MVP: >4 hours → Scope Reduction Protocol
│   ├── Balanced: >1 day → Methodology Pivot Evaluation
│   └── Enterprise: >2 days → Architecture Review Required
└── Is team capacity adequate?
    ├── YES → Technical Recovery Process
    └── NO → Escalation and Resource Reallocation
```

### Time-Boxed Recovery Attempts

#### MVP/Rapid Recovery (Maximum 30 minutes)
- **0-10 minutes**: Environment stabilization and quick fixes
- **10-20 minutes**: Context reconstruction or scope reduction
- **20-30 minutes**: Decision point - continue or restart with reduced scope

#### Balanced/Standard Recovery (Maximum 60 minutes)
- **0-15 minutes**: Comprehensive environment and context analysis
- **15-45 minutes**: Systematic recovery attempts with quality preservation
- **45-60 minutes**: Decision point - continue, pivot methodology, or restart

#### Comprehensive/Enterprise Recovery (Maximum 90 minutes)
- **0-20 minutes**: Full system analysis and impact assessment
- **20-70 minutes**: Thorough recovery with architecture preservation
- **70-90 minutes**: Decision point - continue, architectural review, or escalate

### Framework-Specific Recovery Strategies

#### React/Next.js Recovery
```bash
# Environment validation
npx next info
npm run build --dry-run
rm -rf .next && npm run dev

# Common fixes
rm -rf node_modules package-lock.json && npm install
npm audit fix
npx next lint --fix
```

#### Vue/Nuxt.js Recovery
```bash
# Environment validation
vue --version
npm run build -- --analyze
rm -rf .nuxt && npm run dev

# Common fixes
npm run generate
nuxt typecheck
vue-tsc --noEmit
```

#### Angular Recovery
```bash
# Environment validation
ng version
ng build --configuration=development
ng serve --dry-run

# Common fixes
ng update
npm run lint -- --fix
ng build --prod --source-map
```

#### Vanilla JavaScript Recovery
```bash
# Environment validation
node --version
npm run build
npm run test

# Common fixes
npm run clean && npm run build
npm run lint -- --fix
npm audit fix --force
```

## 🧠 CONTEXT RECONSTRUCTION PROCESS

### Step 1: Mental Model Rebuild (5-10 minutes)

**Information Gathering Checklist**:
- [ ] **Last Session Summary**: Check `docs/progress/context-preservation/` for recent context files
- [ ] **Git History Analysis**: Review last 5 commits with `git log --oneline -5 --stat`
- [ ] **File Change Review**: Check `git diff HEAD~1` for recent modifications
- [ ] **Documentation Review**: Scan relevant methodology docs in `docs/sandbox/[phase]/`
- [ ] **AI Assistant History**: Review conversation summaries if available

**Mental Model Template**:
```markdown
## Context Reconstruction - [TIMESTAMP]

### What I Was Working On
**Primary Goal**: [Main objective of the session]
**Current Component/Feature**: [Specific area of focus]
**Framework Context**: [Technology stack and version]

### What I Had Figured Out
**Key Insights**: [Important discoveries or decisions made]
**Technical Approach**: [Chosen implementation strategy]
**Blockers Identified**: [Known issues or challenges]

### What I Was About To Do
**Next Actions**: [Planned next steps]
**Expected Outcomes**: [What success would look like]
**Time Estimates**: [How long tasks were expected to take]
```

### Step 2: Technical State Analysis (5-10 minutes)

**Code State Checklist**:
- [ ] **Build Status**: Can the project build successfully?
- [ ] **Test Status**: Are existing tests passing?
- [ ] **Dependency Status**: Are all packages installed and compatible?
- [ ] **Configuration Status**: Are build tools and framework configs intact?

**Framework-Specific Validation**:
```bash
# Universal validation commands
npm run build 2>&1 | tee build-status.log
npm test 2>&1 | tee test-status.log
npm run lint 2>&1 | tee lint-status.log

# Check for common issues
find . -name "*.module.css" -exec echo "CSS Module: {}" \;
grep -r "import.*\.module\.css" src/ || echo "No CSS Module imports found"
```

### Step 3: AI Assistant Context Restoration (2-5 minutes)

**Context Restoration Template**:
```markdown
I'm recovering from a derailed development session. Here's my current context:

**Project**: App Development ([Framework])
**Methodology**: [MVP/Balanced/Enterprise] - Week [X] of [Y]
**Last Working State**: [Commit hash or description]
**Current Issue**: [Brief problem description]

**What I Remember**:
- [Key technical decision or insight]
- [Current implementation approach]
- [Specific challenge I was facing]

**What I Need Help With**:
- [Specific question or guidance needed]
- [Framework-specific assistance required]
- [Design system decision needed]

Please help me understand the current state and next steps.
```

## 🔄 SESSION RESTART PROTOCOL

### When to Restart (Any of these conditions)
- [ ] Context reconstruction takes >50% of methodology recovery time limit
- [ ] Technical state is too corrupted to recover efficiently
- [ ] Scope has expanded beyond methodology boundaries
- [ ] Framework/environment issues require complete rebuild

### Clean Slate Procedure

#### Step 1: Knowledge Preservation (5 minutes)
```markdown
## Session Restart Documentation - [TIMESTAMP]

### What Was Attempted
**Original Goal**: [What we were trying to achieve]
**Approach Taken**: [Technical strategy used]
**Progress Made**: [Completed work before derailment]
**Lessons Learned**: [What worked, what didn't]

### Why Restart Was Necessary
**Derailment Cause**: [Root cause of session failure]
**Recovery Attempts**: [What was tried to recover]
**Decision Rationale**: [Why restart was chosen]

### Knowledge to Preserve
**Technical Insights**: [Valuable discoveries to remember]
**Framework Learnings**: [Technology-specific knowledge gained]
**Design System Decisions**: [Architecture or token decisions made]
**Prevention Strategies**: [How to avoid this issue in future]
```

#### Step 2: Environment Reset (10-15 minutes)
```bash
# Universal reset procedure
git stash push -m "pre-restart-backup-$(date +%Y%m%d-%H%M)"
git reset --hard HEAD~1  # Or specific known good commit
rm -rf node_modules package-lock.json
npm cache clean --force
npm install

# Framework-specific reset
# React/Next.js
rm -rf .next out
npm run build

# Vue/Nuxt.js  
rm -rf .nuxt dist
npm run generate

# Angular
rm -rf dist
ng build

# Vanilla JS
rm -rf dist build
npm run build
```

#### Step 3: Methodology Timeline Adjustment (5 minutes)
```markdown
## Timeline Impact Assessment

### Original Timeline
**Methodology**: [MVP/Balanced/Enterprise]
**Phase**: [Current phase] - Week [X] of [Y]
**Planned Completion**: [Original date]

### Restart Impact
**Time Lost**: [Hours/days lost to derailment and restart]
**Adjusted Timeline**: [New realistic completion date]
**Scope Adjustments**: [Features to defer or modify]

### Mitigation Strategies
**Scope Reduction**: [Specific features to cut for MVP]
**Quality Trade-offs**: [Acceptable compromises for Balanced]
**Resource Allocation**: [Additional help needed for Enterprise]
```

## 📋 DOCUMENTATION REQUIREMENTS

### Derailment Incident Template

**File**: `docs/progress/blockers/YYYY-MM-DD_derailment_[session-name]_[methodology].md`

```markdown
# Derailment Incident Report

**Date**: [YYYY-MM-DD]
**Time**: [HH:MM] - [HH:MM]
**Framework**: [React/Vue/Angular/Vanilla]
**Methodology**: [MVP/Balanced/Enterprise]
**Session Phase**: Week [X] of [Y]

## Incident Summary
**Derailment Type**: [Technical/Context/Scope/Environment/Design/Capacity]
**Trigger Event**: [What caused the derailment]
**Impact Severity**: [Low/Medium/High/Critical]
**Recovery Outcome**: [Recovered/Restarted/Escalated]

## Timeline
- **[HH:MM]**: [Normal development in progress]
- **[HH:MM]**: [Derailment trigger event]
- **[HH:MM]**: [Derailment recognized, triage initiated]
- **[HH:MM]**: [Recovery process started]
- **[HH:MM]**: [Recovery completed or restart decision made]

## Technical Details
**Environment State**:
- Framework Version: [Version]
- Node Version: [Version]
- Package Manager: [npm/yarn/pnpm]
- Build Tool: [Webpack/Vite/CLI]

**Error Messages/Symptoms**:
```
[Exact error messages or behavioral descriptions]
```

**Files Affected**:
- `[file-path]`: [Description of impact]
- `[file-path]`: [Description of impact]

## Recovery Process
**Triage Results**:
- Derailment Type: [Identified category]
- Impact Assessment: [Timeline/scope/quality impact]
- Recovery Strategy: [Chosen approach]

**Actions Taken**:
1. [Action 1] - [Time spent] - [Result]
2. [Action 2] - [Time spent] - [Result]
3. [Action 3] - [Time spent] - [Result]

**Framework-Specific Steps**:
- [Framework-specific recovery command/action]
- [Configuration change or fix applied]
- [Dependency or build tool adjustment]

## Outcome Analysis
**Recovery Success**: [Yes/No/Partial]
**Time to Recovery**: [Total time from derailment to resumption]
**Knowledge Preserved**: [What context/progress was saved]
**Knowledge Lost**: [What had to be rediscovered/rebuilt]

## Lessons Learned
**Root Cause**: [Underlying cause of derailment]
**Prevention Strategies**: [How to avoid this in future]
**Process Improvements**: [Changes to make recovery faster]
**Framework Insights**: [Technology-specific learnings]

## Impact on Methodology
**Timeline Adjustment**: [Days added/removed from schedule]
**Scope Changes**: [Features added/removed/modified]
**Quality Trade-offs**: [Standards adjusted for methodology]
**Resource Implications**: [Team capacity or skill needs]
```

### Recovery Time Tracking

**File**: `docs/progress/recovery-metrics.md`

```markdown
# Recovery Time Tracking

## Summary Statistics
**Total Derailments**: [Count]
**Average Recovery Time**: [Minutes]
**Success Rate**: [Percentage recovered vs restarted]
**Most Common Type**: [Derailment category]

## By Methodology
| Methodology | Avg Recovery Time | Success Rate | Common Issues |
|-------------|------------------|--------------|---------------|
| MVP/Rapid | [X] minutes | [X]% | [Issue types] |
| Balanced/Standard | [X] minutes | [X]% | [Issue types] |
| Comprehensive/Enterprise | [X] minutes | [X]% | [Issue types] |

## By Framework
| Framework | Avg Recovery Time | Success Rate | Common Issues |
|-----------|------------------|--------------|---------------|
| React/Next.js | [X] minutes | [X]% | [Issue types] |
| Vue/Nuxt.js | [X] minutes | [X]% | [Issue types] |
| Angular | [X] minutes | [X]% | [Issue types] |
| Vanilla JS | [X] minutes | [X]% | [Issue types] |

## Trend Analysis
**Improving Areas**: [What's getting better]
**Persistent Issues**: [Recurring problems]
**Framework Evolution**: [How framework updates affect recovery]
**Process Effectiveness**: [Which recovery strategies work best]
```

### Lessons Learned Capture

**File**: `docs/knowledge/lessons-learned/YYYY-MM-DD_recovery_[category]_[framework].md`

```markdown
# Recovery Lesson: [Category]

**Date**: [YYYY-MM-DD]
**Framework**: [React/Vue/Angular/Vanilla]
**Methodology**: [MVP/Balanced/Enterprise]
**Lesson Category**: [Technical/Process/Framework/Design System]

## Problem Pattern
**Symptom**: [How the derailment typically manifests]
**Trigger Conditions**: [What circumstances lead to this issue]
**Framework Factors**: [Technology-specific contributing factors]
**Methodology Factors**: [Timeline/scope/quality pressures involved]

## Effective Recovery Strategy
**Approach**: [What recovery method works best]
**Time Investment**: [Typical time to resolve]
**Success Rate**: [How often this approach works]
**Framework Considerations**: [Technology-specific steps or limitations]

## Prevention Strategy
**Early Warning Signs**: [How to detect this issue before derailment]
**Proactive Measures**: [Setup or process changes to prevent]
**Framework Best Practices**: [Technology-specific prevention]
**Methodology Adaptations**: [Timeline/scope adjustments to reduce risk]

## Applicability
**Other Frameworks**: [How this lesson applies to other technologies]
**Other Methodologies**: [How this lesson scales across project types]
**Team Knowledge**: [What expertise is needed to apply this lesson]
**Project Phases**: [When in development lifecycle this is most relevant]
```

## 🔗 INTEGRATION WITH EXISTING PROTOCOLS

### Troubleshooting Protocol Integration

**When to Use Each Process**:
- **Session Recovery**: For derailed sessions requiring immediate triage and recovery
- **Troubleshooting Protocol**: For specific technical problems during normal development

**Handoff Points**:
```markdown
## Recovery to Troubleshooting Handoff

### Use Session Recovery When:
- [ ] Development session has been derailed or interrupted
- [ ] Multiple issues are affecting progress simultaneously
- [ ] Context or mental model has been lost
- [ ] Environment or framework state is uncertain

### Switch to Troubleshooting Protocol When:
- [ ] Session is recovered and stable
- [ ] Specific technical problem identified
- [ ] Normal development flow can resume
- [ ] Problem fits troubleshooting time thresholds (15/30/60 minutes)

### Handoff Documentation:
**Recovery Summary**: [What was recovered and current state]
**Identified Issues**: [Specific problems to address with troubleshooting]
**Context Preserved**: [Mental model and technical understanding]
**Next Actions**: [Specific troubleshooting steps to begin]
```

### Progress Tracking Integration

**Weekly Status Report Updates**:
```markdown
## Session Recovery Impact

### Derailments This Week
- **[Date]**: [Type] - [Recovery time] - [Outcome]
- **[Date]**: [Type] - [Recovery time] - [Outcome]

### Recovery Effectiveness
- **Average Recovery Time**: [X] minutes
- **Success Rate**: [X]% recovered vs restarted
- **Timeline Impact**: [Total days lost/gained]
- **Process Improvements**: [Changes made to prevent future derailments]

### Lessons Applied
- **[Lesson 1]**: [How it helped prevent or resolve derailments]
- **[Lesson 2]**: [How it improved recovery effectiveness]

### Prevention Strategies Implemented
- **[Strategy 1]**: [Implementation details and effectiveness]
- **[Strategy 2]**: [Implementation details and effectiveness]
```

### Milestone Validation Integration

**Derailment Impact on Milestones**:
```markdown
## Milestone Impact Assessment

### Current Milestone: [Milestone Name]
**Original Target**: [Date from methodology roadmap]
**Current Status**: [Percentage complete]
**Derailment Impact**: [Days lost to recovery/restart]

### Validation Criteria Status
- [ ] [Criterion 1]: [Impact from derailments]
- [ ] [Criterion 2]: [Impact from derailments]
- [ ] [Criterion 3]: [Impact from derailments]

### Recovery Adjustments
**Scope Modifications**: [Features deferred due to derailments]
**Timeline Adjustments**: [Realistic completion estimates]
**Quality Considerations**: [Standards adjusted for methodology]
**Resource Needs**: [Additional support required]
```

## 🎯 SPECIFIC RECOVERY SCENARIOS

### Scenario 1: Build System Failure (React/MVP)
**Situation**: npm run dev fails, unclear error messages, 2 hours into 4-hour development block

**Immediate Triage** (2 minutes):
```bash
# Quick assessment
git status
npm --version
node --version
ls -la package*.json
```

**Recovery Steps** (15 minutes max for MVP):
1. **Environment Reset** (5 min):
   ```bash
   rm -rf node_modules package-lock.json .next
   npm cache clean --force
   npm install
   ```

2. **Configuration Validation** (5 min):
   ```bash
   npm run build --verbose
   npx next info
   ```

3. **Fallback Strategy** (5 min):
   ```bash
   git reset --hard HEAD~1  # Last known working state
   npm install
   npm run dev
   ```

**Decision Point**: If not resolved in 15 minutes → Restart with scope reduction

### Scenario 2: Context Loss After Interruption (Vue/Balanced)
**Situation**: 3-hour interruption, lost mental model, Week 4 of 6-week project

**Context Reconstruction** (20 minutes max for Balanced):
1. **Git History Analysis** (5 min):
   ```bash
   git log --oneline -10 --stat
   git show HEAD --name-only
   git diff HEAD~2..HEAD
   ```

2. **Documentation Review** (10 min):
   - Check `docs/progress/context-preservation/` for recent files
   - Review methodology documentation for current phase
   - Scan component files for TODO comments and recent changes

3. **AI Assistant Restoration** (5 min):
   ```markdown
   I'm recovering context after a 3-hour interruption. Here's what I can piece together:

   **Last Commit**: [commit message and hash]
   **Modified Files**: [list from git status]
   **Current Phase**: Week 4 of Balanced methodology - [phase name]

   Can you help me understand what I was working on and what the next logical steps would be?
   ```

### Scenario 3: Scope Creep Derailment (Angular/Enterprise)
**Situation**: Feature requirements expanded 40%, Week 8 of 12-week project

**Scope Management** (30 minutes max for Enterprise):
1. **Impact Assessment** (10 min):
   ```markdown
   ## Scope Expansion Analysis
   **Original Scope**: [List original features]
   **New Requirements**: [List added features]
   **Expansion Percentage**: 40%
   **Timeline Impact**: [Calculate additional weeks needed]
   ```

2. **Stakeholder Communication** (10 min):
   ```markdown
   ## Scope Change Impact Report
   **Current Status**: Week 8 of 12 (67% complete)
   **New Requirements**: [List with effort estimates]
   **Options**:
   1. Extend timeline by [X] weeks
   2. Defer [specific features] to Phase 2
   3. Reduce quality standards for [specific areas]

   **Recommendation**: [Based on Enterprise methodology constraints]
   ```

3. **Recovery Strategy** (10 min):
   - Document scope changes in methodology documentation
   - Update milestone validation criteria
   - Adjust progress tracking templates
   - Implement scope freeze for remaining timeline

### Scenario 4: Framework Version Conflict (Vanilla JS/MVP)
**Situation**: Dependency update broke CSS Modules, Day 8 of 14-day MVP

**Emergency Resolution** (20 minutes max for MVP):
1. **Immediate Rollback** (5 min):
   ```bash
   git log --oneline -5
   git reset --hard [last-working-commit]
   npm install
   ```

2. **Dependency Lock** (5 min):
   ```bash
   npm shrinkwrap  # Lock current working versions
   echo "# Dependency freeze for MVP completion" >> package.json
   ```

3. **Documentation** (10 min):
   ```markdown
   ## MVP Dependency Freeze
   **Reason**: Version conflict breaking CSS Modules
   **Frozen At**: [commit hash]
   **Post-MVP Action**: Investigate and resolve dependency conflicts
   **Risk**: Security updates deferred until post-MVP
   ```

**Decision**: Accept technical debt for MVP timeline, schedule post-MVP cleanup

### Scenario 5: Design System Architecture Conflict (React/Balanced)
**Situation**: Token inheritance breaking component styling, Week 5 of 7-week project

**Architecture Recovery** (45 minutes max for Balanced):
1. **Conflict Analysis** (15 min):
   ```bash
   # Identify affected components
   grep -r "var(--" src/components/
   find src/ -name "*.module.css" -exec grep -l "inherit" {} \;
   ```

2. **Impact Assessment** (15 min):
   ```markdown
   ## Design System Conflict Analysis
   **Affected Components**: [List with file paths]
   **Token Conflicts**: [Specific CSS custom properties]
   **User Impact**: [Visual/functional issues]
   **Framework Factors**: [React-specific considerations]
   ```

3. **Resolution Strategy** (15 min):
   - Choose between global token refactor vs component-level fixes
   - Implement solution based on Balanced methodology quality standards
   - Update design system documentation
   - Test across affected components

## 📚 QUICK REFERENCE GUIDES

### Emergency Commands by Framework

#### React/Next.js Emergency Kit
```bash
# Environment reset
rm -rf .next node_modules package-lock.json && npm install

# Build diagnostics
npm run build 2>&1 | tee build-log.txt
npx next info

# Common fixes
npm audit fix
npx next lint --fix
npm run type-check
```

#### Vue/Nuxt.js Emergency Kit
```bash
# Environment reset
rm -rf .nuxt node_modules package-lock.json && npm install

# Build diagnostics
npm run build -- --analyze 2>&1 | tee build-log.txt
vue --version

# Common fixes
npm run generate
nuxt typecheck
vue-tsc --noEmit
```

#### Angular Emergency Kit
```bash
# Environment reset
rm -rf dist node_modules package-lock.json && npm install

# Build diagnostics
ng build --configuration=development 2>&1 | tee build-log.txt
ng version

# Common fixes
ng update
ng lint --fix
ng build --prod --source-map
```

#### Vanilla JavaScript Emergency Kit
```bash
# Environment reset
rm -rf dist build node_modules package-lock.json && npm install

# Build diagnostics
npm run build 2>&1 | tee build-log.txt
node --version

# Common fixes
npm run clean && npm run build
npm run lint -- --fix
npm audit fix
```

### Recovery Time Limits by Methodology

| Methodology | Max Recovery Time | Decision Point | Fallback Strategy |
|-------------|------------------|----------------|-------------------|
| **MVP/Rapid** | 30 minutes | 20 minutes | Scope reduction, technical debt |
| **Balanced/Standard** | 60 minutes | 45 minutes | Quality trade-offs, timeline adjustment |
| **Comprehensive/Enterprise** | 90 minutes | 70 minutes | Architecture review, resource escalation |

### Derailment Type Quick Actions

| Type | Immediate Action | Time Limit | Success Criteria |
|------|-----------------|------------|------------------|
| **Technical Blocker** | Environment reset | 15-30 min | Build/test passing |
| **Context Loss** | Documentation review | 10-20 min | Mental model restored |
| **Scope Creep** | Impact assessment | 20-30 min | Scope decision made |
| **Environment Failure** | Git reset + rebuild | 10-25 min | Development resumable |
| **Design System Conflict** | Component analysis | 30-45 min | Architecture decision |
| **Capacity Change** | Resource assessment | 15-30 min | Mitigation plan |

## ✅ SUCCESS VALIDATION

### Recovery Success Criteria
- [ ] **Environment Functional**: Build, test, and dev server working
- [ ] **Context Restored**: Mental model and technical understanding recovered
- [ ] **Timeline Preserved**: Recovery time within methodology limits
- [ ] **Quality Maintained**: Standards appropriate for methodology preserved
- [ ] **Documentation Updated**: Incident and lessons captured

### Process Effectiveness Metrics
- **Recovery Initiation**: <2 minutes from derailment recognition
- **Triage Completion**: <5 minutes for assessment and stabilization
- **Recovery Success Rate**: >80% within methodology time limits
- **Context Preservation**: >90% of development context maintained
- **Knowledge Retention**: Lessons captured for future prevention

### Integration Validation
- [ ] **Troubleshooting Protocol**: Seamless handoff when recovery complete
- [ ] **Progress Tracking**: Derailment impact documented in weekly reports
- [ ] **Milestone Validation**: Timeline adjustments reflected in milestone criteria
- [ ] **Methodology Compliance**: Recovery approach aligns with chosen methodology

---

**End of Session Recovery Process**

*This recovery process provides immediate, actionable guidance for recovering from derailed development sessions while preserving context and maintaining methodology timeline adherence across all supported frameworks.*
