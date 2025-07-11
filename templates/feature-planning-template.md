# Feature Planning Template
## AI-Assisted Development with Methodology Integration

**Instructions**: Copy this template for each new feature and fill in all sections before beginning development. This template is optimized for AI-assisted development with 1-hour sub-phase constraints and methodology-specific guidance.

**Completion Strategy Integration**: For systematic planning of multiple features, use the Completion Strategy Template System:
- Generate completion strategy: `./workflows/generate-completion-strategy.sh --project-name "YourProject" --methodology "your-methodology"`
- Reference: `templates/README-completion-strategy.md` for detailed guidance
- Scale to 100+ features: Use completion strategy for consistent, efficient feature planning

---

# Feature: {{FEATURE_NAME}}

## Overview
- **Description**: {{FEATURE_DESCRIPTION}}
- **Methodology**: {{METHODOLOGY_CHOICE}} (Business-Value/User-Centric/Technology-Innovation)
- **Estimated Duration**: {{TOTAL_DURATION}} (Maximum 4-6 hours total, broken into 1-hour sub-phases)
- **Priority**: {{PRIORITY_LEVEL}} (High/Medium/Low)
- **Feature Owner**: {{FEATURE_OWNER}}
- **Start Date**: {{START_DATE}}
- **Target Completion**: {{TARGET_COMPLETION_DATE}}

## Methodology-Specific Framework

### Business-Value Approach
*Complete this section if using Business-Value methodology*
- **ROI Target**: {{ROI_TARGET}}
- **Business Metrics**: {{BUSINESS_METRICS_TO_TRACK}}
- **Market Impact**: {{EXPECTED_MARKET_IMPACT}}
- **Revenue Potential**: {{REVENUE_POTENTIAL}}
- **Cost-Benefit Analysis**: {{COST_BENEFIT_SUMMARY}}

### User-Centric Approach
*Complete this section if using User-Centric methodology*
- **Target Users**: {{TARGET_USER_PERSONAS}}
- **User Research Required**: {{USER_RESEARCH_NEEDS}}
- **Accessibility Requirements**: {{ACCESSIBILITY_STANDARDS}}
- **Usability Testing Plan**: {{USABILITY_TESTING_APPROACH}}
- **User Success Metrics**: {{USER_SUCCESS_METRICS}}

### Technology-Innovation Approach
*Complete this section if using Technology-Innovation methodology*
- **Technical Innovation**: {{TECHNICAL_INNOVATION_GOALS}}
- **Performance Targets**: {{PERFORMANCE_BENCHMARKS}}
- **Technology Stack**: {{TECHNOLOGY_CHOICES}}
- **Scalability Requirements**: {{SCALABILITY_TARGETS}}
- **Innovation Metrics**: {{INNOVATION_SUCCESS_METRICS}}

## AI-Assisted Development Structure

### Phase 1: Planning & Setup (Max 1 Hour)
**AI Context Window Scope**: Initial planning and environment setup
- **Duration**: {{SUBPHASE_1_DURATION}} (≤ 60 minutes)
- **Deliverables**:
  - [ ] Feature specification finalized
  - [ ] Development environment configured
  - [ ] Git branch created and initial commit made
  - [ ] Dependencies identified and documented
- **AI Handoff Notes**: {{SUBPHASE_1_HANDOFF_NOTES}}

### Phase 2: Core Implementation (Max 1 Hour)
**AI Context Window Scope**: Primary feature development
- **Duration**: {{SUBPHASE_2_DURATION}} (≤ 60 minutes)
- **Deliverables**:
  - [ ] Core functionality implemented
  - [ ] Basic CSS Modules styling applied
  - [ ] Initial testing completed
  - [ ] Progress commit made
- **AI Handoff Notes**: {{SUBPHASE_2_HANDOFF_NOTES}}

### Phase 3: Integration & Testing (Max 1 Hour)
**AI Context Window Scope**: Feature integration and validation
- **Duration**: {{SUBPHASE_3_DURATION}} (≤ 60 minutes)
- **Deliverables**:
  - [ ] Feature integrated with existing codebase
  - [ ] Comprehensive testing completed
  - [ ] Bug fixes and refinements made
  - [ ] Integration commit made
- **AI Handoff Notes**: {{SUBPHASE_3_HANDOFF_NOTES}}

### Phase 4: Polish & Documentation (Max 1 Hour)
**AI Context Window Scope**: Final refinements and documentation
- **Duration**: {{SUBPHASE_4_DURATION}} (≤ 60 minutes)
- **Deliverables**:
  - [ ] UI/UX polish and accessibility validation
  - [ ] Documentation updated
  - [ ] Code review preparation
  - [ ] Final commit and pull request creation
- **AI Handoff Notes**: {{SUBPHASE_4_HANDOFF_NOTES}}

## Git Workflow Integration

### Branch Management
- **Branch Naming Convention**: `{{METHODOLOGY_PREFIX}}/{{FEATURE_TYPE}}/{{FEATURE_NAME}}`
  - Business-Value: `bv/feature/{{FEATURE_NAME}}`
  - User-Centric: `uc/feature/{{FEATURE_NAME}}`
  - Technology-Innovation: `ti/feature/{{FEATURE_NAME}}`
- **Base Branch**: {{BASE_BRANCH}} (typically `main` or `develop`)
- **Branch Creation**: 
  ```bash
  git checkout {{BASE_BRANCH}}
  git pull origin {{BASE_BRANCH}}
  git checkout -b {{BRANCH_NAME}}
  ```

### Commit Standards
- **Commit Message Format**: `{{METHODOLOGY_PREFIX}}({{SCOPE}}): {{DESCRIPTION}}`
  - Example: `bv(auth): implement user login validation`
  - Example: `uc(accessibility): add ARIA labels to form inputs`
  - Example: `ti(performance): optimize database query caching`
- **Commit Frequency**: Minimum one commit per sub-phase, additional commits as needed
- **Commit Types**: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`

### Pull Request Process
- **PR Title**: `[{{METHODOLOGY}}] {{FEATURE_NAME}}: {{BRIEF_DESCRIPTION}}`
- **PR Description Template**:
  ```markdown
  ## Methodology: {{METHODOLOGY_CHOICE}}
  
  ### Feature Description
  {{FEATURE_DESCRIPTION}}
  
  ### Methodology-Specific Validation
  - [ ] {{METHODOLOGY_SPECIFIC_CHECKLIST_ITEM_1}}
  - [ ] {{METHODOLOGY_SPECIFIC_CHECKLIST_ITEM_2}}
  
  ### Technical Changes
  - {{TECHNICAL_CHANGE_1}}
  - {{TECHNICAL_CHANGE_2}}
  
  ### Testing Completed
  - [ ] Unit tests
  - [ ] Integration tests
  - [ ] {{METHODOLOGY_SPECIFIC_TESTING}}
  ```

### Code Review Protocols
- **Reviewers Required**: {{REQUIRED_REVIEWERS}} (minimum 1, methodology expert preferred)
- **Review Criteria**:
  - [ ] Methodology alignment validated
  - [ ] CSS Modules implementation correct
  - [ ] Code quality standards met
  - [ ] Testing coverage adequate
  - [ ] Documentation updated
- **Review Timeline**: {{REVIEW_TIMELINE}} (target: 24 hours)

### Merge Strategy
- **Merge Type**: {{MERGE_STRATEGY}} (squash/merge/rebase)
- **Merge Requirements**:
  - [ ] All CI/CD checks passing
  - [ ] Required approvals received
  - [ ] Conflicts resolved
  - [ ] Branch up-to-date with base
- **Post-Merge Actions**:
  - [ ] Feature branch deleted
  - [ ] Deployment triggered (if applicable)
  - [ ] Stakeholders notified

## Business Requirements

### Functional Requirements
- [ ] **{{FUNCTIONAL_REQ_1}}**: {{FUNCTIONAL_REQ_1_DESCRIPTION}}
- [ ] **{{FUNCTIONAL_REQ_2}}**: {{FUNCTIONAL_REQ_2_DESCRIPTION}}
- [ ] **{{FUNCTIONAL_REQ_3}}**: {{FUNCTIONAL_REQ_3_DESCRIPTION}}

### Non-Functional Requirements
- [ ] **Performance**: {{PERFORMANCE_TARGETS}}
- [ ] **Security**: {{SECURITY_REQUIREMENTS}}
- [ ] **Accessibility**: {{ACCESSIBILITY_STANDARDS}} (WCAG 2.1 AA minimum)
- [ ] **Scalability**: {{SCALABILITY_REQUIREMENTS}}
- [ ] **Usability**: {{USABILITY_REQUIREMENTS}}

## Technical Specifications

### CSS Modules Implementation
- **Styling Approach**: CSS Modules with design tokens
- **Component Styles**: `{{COMPONENT_NAME}}.module.css`
- **Design Tokens Used**: {{DESIGN_TOKENS_LIST}}
- **Responsive Breakpoints**: {{RESPONSIVE_BREAKPOINTS}}
- **Accessibility Considerations**: {{ACCESSIBILITY_CSS_REQUIREMENTS}}

### Core Features Integration

#### Authentication
- **Required**: {{AUTH_REQUIRED}} (Yes/No)
- **Type**: {{AUTH_TYPE}} (Login/Registration/Permission-based/Role-based)
- **Integration Points**: {{AUTH_INTEGRATION_POINTS}}
- **Security Considerations**: {{AUTH_SECURITY_REQUIREMENTS}}

#### Database
- **Changes Required**: {{DB_CHANGES_REQUIRED}} (Yes/No)
- **New Tables/Collections**: {{NEW_DATA_STRUCTURES}}
- **Schema Modifications**: {{SCHEMA_CHANGES}}
- **Migration Strategy**: {{MIGRATION_APPROACH}}
- **Performance Considerations**: {{DB_PERFORMANCE_REQUIREMENTS}}

#### API
- **New Endpoints**: {{NEW_API_ENDPOINTS}}
- **Endpoint Modifications**: {{API_MODIFICATIONS}}
- **Request/Response Schemas**: {{API_SCHEMAS}}
- **Error Handling**: {{API_ERROR_SCENARIOS}}
- **Rate Limiting**: {{RATE_LIMITING_REQUIREMENTS}}

#### State Management
- **State Requirements**: {{STATE_MANAGEMENT_NEEDS}}
- **State Scope**: {{STATE_SCOPE}} (Local/Global/Persistent)
- **Caching Strategy**: {{CACHING_APPROACH}}
- **Synchronization**: {{SYNC_REQUIREMENTS}}

#### Error Handling
- **Error Scenarios**: {{ERROR_SCENARIOS}}
- **Error Recovery**: {{ERROR_RECOVERY_STRATEGY}}
- **User Messaging**: {{ERROR_USER_COMMUNICATION}}
- **Logging Requirements**: {{LOGGING_REQUIREMENTS}}

#### Testing Strategy
- **Unit Testing**: {{UNIT_TESTING_SCOPE}}
- **Integration Testing**: {{INTEGRATION_TESTING_SCOPE}}
- **End-to-End Testing**: {{E2E_TESTING_SCOPE}}
- **Performance Testing**: {{PERFORMANCE_TESTING_SCOPE}}
- **Security Testing**: {{SECURITY_TESTING_SCOPE}}
- **Accessibility Testing**: {{ACCESSIBILITY_TESTING_SCOPE}}

## Success Criteria

### Methodology-Specific Success Criteria
*Complete based on chosen methodology*

#### Business-Value Success Criteria
- [ ] **ROI Achievement**: {{ROI_SUCCESS_METRIC}}
- [ ] **Business Metrics**: {{BUSINESS_SUCCESS_METRICS}}
- [ ] **Market Impact**: {{MARKET_SUCCESS_INDICATORS}}

#### User-Centric Success Criteria
- [ ] **User Satisfaction**: {{USER_SATISFACTION_METRICS}}
- [ ] **Accessibility Compliance**: {{ACCESSIBILITY_SUCCESS_CRITERIA}}
- [ ] **Usability Metrics**: {{USABILITY_SUCCESS_INDICATORS}}

#### Technology-Innovation Success Criteria
- [ ] **Performance Benchmarks**: {{PERFORMANCE_SUCCESS_METRICS}}
- [ ] **Technical Excellence**: {{TECHNICAL_SUCCESS_CRITERIA}}
- [ ] **Innovation Metrics**: {{INNOVATION_SUCCESS_INDICATORS}}

### Universal Success Criteria
- [ ] **Functional**: {{FUNCTIONAL_SUCCESS_CRITERIA}}
- [ ] **Technical Quality**: {{TECHNICAL_QUALITY_METRICS}}
- [ ] **Code Coverage**: {{CODE_COVERAGE_TARGET}}% minimum
- [ ] **CSS Modules**: All styling implemented with design tokens
- [ ] **Documentation**: Complete and up-to-date

## Dependencies and Prerequisites

### Internal Dependencies
- [ ] **{{INTERNAL_DEP_1}}**: {{INTERNAL_DEP_1_STATUS}}
- [ ] **{{INTERNAL_DEP_2}}**: {{INTERNAL_DEP_2_STATUS}}
- [ ] **{{INTERNAL_DEP_3}}**: {{INTERNAL_DEP_3_STATUS}}

### External Dependencies
- [ ] **{{EXTERNAL_DEP_1}}**: {{EXTERNAL_DEP_1_REQUIREMENTS}}
- [ ] **{{EXTERNAL_DEP_2}}**: {{EXTERNAL_DEP_2_REQUIREMENTS}}

### Infrastructure Dependencies
- [ ] **Environment Setup**: {{ENVIRONMENT_REQUIREMENTS}}
- [ ] **Database Changes**: {{DATABASE_SETUP_REQUIREMENTS}}
- [ ] **Configuration**: {{CONFIGURATION_CHANGES}}

## Risk Assessment and Mitigation

### Technical Risks
- **{{TECHNICAL_RISK_1}}**: 
  - **Probability**: {{RISK_1_PROBABILITY}}
  - **Impact**: {{RISK_1_IMPACT}}
  - **Mitigation Strategy**: {{RISK_1_MITIGATION}}

### Methodology-Specific Risks
- **{{METHODOLOGY_RISK_1}}**: 
  - **Probability**: {{METHOD_RISK_1_PROBABILITY}}
  - **Impact**: {{METHOD_RISK_1_IMPACT}}
  - **Mitigation Strategy**: {{METHOD_RISK_1_MITIGATION}}

### AI-Assisted Development Risks
- **Context Window Limitations**: 
  - **Probability**: Medium
  - **Impact**: Medium
  - **Mitigation Strategy**: Clear handoff documentation between sub-phases

- **Time Constraint Pressure**: 
  - **Probability**: Medium
  - **Impact**: Medium
  - **Mitigation Strategy**: Scope reduction and priority focus within sub-phases

## Validation and Acceptance

### Development Validation
- [ ] All functional requirements implemented
- [ ] Methodology-specific criteria met
- [ ] CSS Modules implementation validated
- [ ] Code review completed and approved
- [ ] All tests passing ({{TEST_COVERAGE_TARGET}}% coverage minimum)
- [ ] Performance targets met
- [ ] Security requirements satisfied
- [ ] Accessibility standards validated

### User Acceptance
- [ ] {{METHODOLOGY_SPECIFIC_USER_ACCEPTANCE}}
- [ ] Accessibility testing completed
- [ ] Documentation reviewed and approved
- [ ] Stakeholder sign-off received

## AI Context Preservation

### Sub-Phase Handoff Protocol
1. **Context Summary**: Brief summary of completed work
2. **Current State**: Exact state of codebase and implementation
3. **Next Steps**: Clear instructions for next sub-phase
4. **Blockers/Issues**: Any unresolved issues or dependencies
5. **Methodology Notes**: Methodology-specific considerations for next phase

### Context Documentation
- **Sub-Phase 1 → 2**: {{CONTEXT_HANDOFF_1_TO_2}}
- **Sub-Phase 2 → 3**: {{CONTEXT_HANDOFF_2_TO_3}}
- **Sub-Phase 3 → 4**: {{CONTEXT_HANDOFF_3_TO_4}}

## Time Management and Scope Control

### 1-Hour Sub-Phase Guidelines
- **Maximum Scope**: Each sub-phase must be completable within 60 minutes
- **Scope Reduction Strategy**: If sub-phase exceeds time limit, reduce scope rather than extend time
- **Priority Focus**: Complete highest-priority items first within each sub-phase
- **Checkpoint Protocol**: 45-minute checkpoint to assess progress and adjust scope if needed

### Time Estimation Framework
```markdown
## Sub-Phase Time Allocation

| Sub-Phase | Core Tasks (40 min) | Buffer/Polish (15 min) | Handoff Docs (5 min) |
|-----------|---------------------|------------------------|----------------------|
| Planning  | {{PLANNING_CORE_TASKS}} | {{PLANNING_BUFFER}} | {{PLANNING_HANDOFF}} |
| Implementation | {{IMPL_CORE_TASKS}} | {{IMPL_BUFFER}} | {{IMPL_HANDOFF}} |
| Integration | {{INTEGRATION_CORE_TASKS}} | {{INTEGRATION_BUFFER}} | {{INTEGRATION_HANDOFF}} |
| Polish | {{POLISH_CORE_TASKS}} | {{POLISH_BUFFER}} | {{POLISH_HANDOFF}} |
```

### Scope Boundary Definitions
- **Must Have**: Core functionality required for feature to work
- **Should Have**: Important enhancements that improve the feature
- **Could Have**: Nice-to-have improvements that can be deferred
- **Won't Have**: Features explicitly excluded from current scope

## Conflict Resolution Procedures

### Git Merge Conflicts
1. **Prevention Strategy**: Regular pulls from base branch during development
2. **Resolution Process**:
   ```bash
   git checkout {{BASE_BRANCH}}
   git pull origin {{BASE_BRANCH}}
   git checkout {{FEATURE_BRANCH}}
   git rebase {{BASE_BRANCH}}
   # Resolve conflicts in IDE
   git add .
   git rebase --continue
   ```
3. **Escalation Path**: If conflicts are complex, involve methodology expert or senior developer
4. **Documentation**: Document resolution decisions for future reference

### Methodology Conflicts
- **Business vs User**: Prioritize user needs while maintaining business viability
- **User vs Technology**: Balance user experience with technical constraints
- **Technology vs Business**: Evaluate long-term technical debt against short-term business gains

## Quality Assurance Integration

### CSS Modules Quality Checklist
- [ ] All styles use design tokens from `design-tokens.css`
- [ ] Component styles are properly scoped with `.module.css` extension
- [ ] No hardcoded values (colors, spacing, typography)
- [ ] Responsive design implemented with consistent breakpoints
- [ ] Accessibility considerations included in styling
- [ ] Cross-browser compatibility validated

### Methodology-Specific Quality Gates

#### Business-Value Quality Gates
- [ ] ROI calculation validated and documented
- [ ] Business metrics tracking implemented
- [ ] Market impact assessment completed
- [ ] Cost-benefit analysis reviewed and approved

#### User-Centric Quality Gates
- [ ] User research findings incorporated
- [ ] Accessibility standards met (WCAG 2.1 AA)
- [ ] Usability testing completed with target users
- [ ] User feedback collection mechanism implemented

#### Technology-Innovation Quality Gates
- [ ] Performance benchmarks met or exceeded
- [ ] Technical innovation goals achieved
- [ ] Scalability requirements validated
- [ ] Code quality metrics meet excellence standards

## Cross-Methodology Integration Points

### Handoff Procedures
1. **Business-Value → User-Centric**: Business requirements and constraints documentation
2. **User-Centric → Technology-Innovation**: User experience requirements and technical specifications
3. **Technology-Innovation → Business-Value**: Technical capabilities and performance metrics

### Shared Success Metrics
- **Quality**: Code coverage ≥ {{CODE_COVERAGE_TARGET}}%, performance within targets
- **Accessibility**: WCAG 2.1 AA compliance across all methodologies
- **Maintainability**: Technical debt score within acceptable limits
- **Documentation**: Complete and up-to-date for all methodologies

## Emergency Procedures

### Time Overrun Protocol
1. **15-minute warning**: Assess remaining tasks and prioritize
2. **5-minute warning**: Complete current task and prepare handoff
3. **Time exceeded**: Stop development, document current state, plan continuation

### Scope Creep Management
1. **Identification**: Regular scope validation against original requirements
2. **Assessment**: Evaluate impact on timeline and methodology goals
3. **Decision**: Approve, defer, or reject scope changes
4. **Documentation**: Record all scope change decisions and rationale

### Technical Blocker Resolution
1. **Immediate**: Attempt quick resolution within 15 minutes
2. **Short-term**: Document blocker and continue with alternative approach
3. **Long-term**: Escalate to technical expert or defer to next sub-phase

## Notes and Additional Considerations

{{ADDITIONAL_NOTES_AND_CONSIDERATIONS}}

### Methodology-Specific Notes
- **Business-Value**: {{BUSINESS_VALUE_SPECIFIC_NOTES}}
- **User-Centric**: {{USER_CENTRIC_SPECIFIC_NOTES}}
- **Technology-Innovation**: {{TECHNOLOGY_INNOVATION_SPECIFIC_NOTES}}

### AI-Assisted Development Notes
- **Context Preservation**: {{CONTEXT_PRESERVATION_STRATEGY}}
- **Handoff Quality**: {{HANDOFF_QUALITY_REQUIREMENTS}}
- **Time Management**: {{TIME_MANAGEMENT_SPECIFIC_NOTES}}

---

**Template Version**: 2.0 (AI-Assisted Development Enhanced)
**Last Updated**: {{LAST_UPDATED_DATE}}
**Methodology Framework**: Business-Value | User-Centric | Technology-Innovation
**AI-Assisted Development**: Optimized for 1-hour sub-phases with context preservation
**Git Workflow**: Integrated branch management and methodology-specific commit standards
**CSS Modules**: Full integration with design token system and responsive design patterns
**Related Documentation**: {{RELATED_DOCUMENTATION_LINKS}}
