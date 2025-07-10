# Conception to Development Prompt Chain

## Overview
This prompt chain guides you through the complete process from initial project conception to development readiness using your chosen methodology. Each step builds on the previous one and maintains methodology consistency.

## Chain Sequence

### Step 1: Project Context Establishment
**Purpose**: Establish project context and methodology selection
**Duration**: 5-10 minutes

```
I'm starting a new project and need to establish the foundation using the AI-Assisted Solo Development framework.

Project Details:
- Project Name: {{PROJECT_NAME}}
- Initial Idea: {{PROJECT_IDEA}}
- Target Users: {{TARGET_USERS}}
- Goals: {{PROJECT_GOALS}}

Help me:
1. Refine my project idea into a clear problem statement
2. Identify the most appropriate methodology (User-Centric, Technology-Innovation, or Business-Value)
3. Set up the initial project context for AI assistance

Please ask clarifying questions to understand:
- What success looks like for this project
- Who the primary beneficiaries are
- What constraints or requirements exist
- What my primary focus should be (user experience, technical innovation, or business value)

Based on my responses, recommend the optimal methodology and provide a refined project context.
```

### Step 2: Methodology-Specific Problem Definition
**Purpose**: Define the problem using methodology-specific approach
**Duration**: 15-30 minutes

```
Based on our previous discussion, I'm proceeding with {{METHODOLOGY}} methodology for "{{PROJECT_NAME}}".

Project Context:
{{PROJECT_CONTEXT_FROM_STEP_1}}

Now help me define the core problem using {{METHODOLOGY}} methodology principles:

{{INCLUDE: ../conception/{{METHODOLOGY}}/problem-definition.md}}

Focus on:
1. {{METHODOLOGY}}-specific problem analysis
2. Validation criteria aligned with {{METHODOLOGY}} priorities
3. Success metrics that match {{METHODOLOGY}} focus
4. Risk assessment from {{METHODOLOGY}} perspective

Provide a comprehensive problem definition that I can validate and refine.
```

### Step 3: Solution Approach Validation
**Purpose**: Validate solution approach using methodology criteria
**Duration**: 20-30 minutes

```
I've defined the problem for "{{PROJECT_NAME}}" using {{METHODOLOGY}} methodology:

Problem Definition:
{{PROBLEM_DEFINITION_FROM_STEP_2}}

Now help me validate and refine potential solution approaches:

{{INCLUDE: ../conception/{{METHODOLOGY}}/solution-validation.md}}

Evaluate potential solutions against {{METHODOLOGY}} criteria:
{{INCLUDE: ../../methodologies/{{METHODOLOGY}}/conception-criteria.md}}

Provide:
1. Solution approach recommendations aligned with {{METHODOLOGY}}
2. Validation plan for testing solution assumptions
3. Success criteria and measurement approach
4. Risk mitigation strategies
5. Next steps for moving to technology selection

Ensure all recommendations prioritize {{METHODOLOGY}} principles and success metrics.
```

### Step 4: Technology Requirements Definition
**Purpose**: Define technology requirements based on methodology and solution approach
**Duration**: 15-20 minutes

```
I've validated my solution approach for "{{PROJECT_NAME}}" using {{METHODOLOGY}} methodology:

Solution Approach:
{{SOLUTION_APPROACH_FROM_STEP_3}}

Now help me define technology requirements that support my {{METHODOLOGY}} methodology:

Technology Requirements Analysis:
1. What technology characteristics are most important for {{METHODOLOGY}} success?
2. What performance, scalability, or capability requirements exist?
3. What development tools and frameworks align with {{METHODOLOGY}} priorities?
4. What technology constraints or preferences should guide selection?

{{METHODOLOGY}} Technology Priorities:
{{INCLUDE: ../../methodologies/{{METHODOLOGY}}/technology-criteria.md}}

Provide:
- Technology requirement specifications
- Evaluation criteria for technology selection
- Must-have vs. nice-to-have technology features
- Technology selection process recommendations
- Preparation for Phase 1 (Technology Selection)

Ensure technology requirements support {{METHODOLOGY}} success criteria and solution approach.
```

### Step 5: Project Setup and Planning
**Purpose**: Plan project structure and development approach
**Duration**: 15-20 minutes

```
I'm ready to set up "{{PROJECT_NAME}}" for development using {{METHODOLOGY}} methodology:

Project Foundation:
- Problem: {{VALIDATED_PROBLEM}}
- Solution: {{VALIDATED_SOLUTION}}
- Technology Requirements: {{TECHNOLOGY_REQUIREMENTS}}
- Methodology: {{METHODOLOGY}}

Help me plan the project setup and development approach:

1. **Project Structure Planning**
   - What project organization supports {{METHODOLOGY}} development?
   - How should I structure documentation and decision tracking?
   - What development workflow aligns with {{METHODOLOGY}} principles?

2. **Phase Planning**
   - How should I approach the 8 project lifecycle phases?
   - What {{METHODOLOGY}}-specific considerations exist for each phase?
   - What validation checkpoints should I establish?

3. **Success Measurement**
   - What metrics should I track throughout development?
   - How should I validate {{METHODOLOGY}} success criteria?
   - What feedback loops and iteration cycles should I establish?

4. **AI Assistance Strategy**
   - How should I structure AI interactions for consistency?
   - What context preservation strategies should I use?
   - How can I maintain {{METHODOLOGY}} alignment in AI assistance?

Provide a comprehensive project setup plan that enables successful {{METHODOLOGY}}-driven development.
```

## Chain Validation Checklist

### After Step 1: Context Establishment
- [ ] Project idea is clearly articulated
- [ ] Methodology selection is justified and appropriate
- [ ] Initial project context is established
- [ ] Success criteria are defined

### After Step 2: Problem Definition
- [ ] Problem is defined using methodology-specific approach
- [ ] Problem validation plan is created
- [ ] Success metrics align with methodology priorities
- [ ] Risk assessment reflects methodology perspective

### After Step 3: Solution Validation
- [ ] Solution approach aligns with methodology principles
- [ ] Solution validation plan is comprehensive
- [ ] Success criteria are measurable and methodology-specific
- [ ] Risk mitigation strategies are defined

### After Step 4: Technology Requirements
- [ ] Technology requirements support methodology success
- [ ] Evaluation criteria reflect methodology priorities
- [ ] Technology constraints and preferences are clear
- [ ] Technology selection process is defined

### After Step 5: Project Setup
- [ ] Project structure supports methodology development
- [ ] Phase planning aligns with methodology approach
- [ ] Success measurement framework is established
- [ ] AI assistance strategy is defined

## Context Preservation Between Steps

### Information to Carry Forward
- Project name and core idea
- Chosen methodology and rationale
- Problem definition and validation
- Solution approach and requirements
- Technology requirements and constraints
- Success criteria and metrics
- Risk assessment and mitigation strategies

### Context Template for Each Step
```
Project: {{PROJECT_NAME}}
Methodology: {{METHODOLOGY}}
Previous Step Output: {{PREVIOUS_STEP_RESULTS}}
Current Step Goal: {{CURRENT_STEP_OBJECTIVE}}
Methodology Focus: {{METHODOLOGY_PRIORITIES}}
```

## Troubleshooting Common Issues

### If Methodology Selection is Unclear
- Review project goals and success criteria
- Consider primary stakeholders and beneficiaries
- Assess competitive advantage and differentiation
- Re-run methodology selection wizard

### If Problem Definition is Weak
- Gather more validation data (user research, market analysis, technical feasibility)
- Refine problem scope and focus
- Strengthen methodology-specific analysis
- Validate assumptions with target audience

### If Solution Approach Doesn't Align
- Revisit problem definition for clarity
- Ensure solution addresses methodology priorities
- Consider alternative approaches
- Validate solution assumptions

### If Technology Requirements are Vague
- Clarify solution approach and constraints
- Research methodology-specific technology needs
- Consult technology selection criteria
- Define must-have vs. nice-to-have features

This prompt chain ensures comprehensive project foundation while maintaining methodology consistency throughout the conception process.
