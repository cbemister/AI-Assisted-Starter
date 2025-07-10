#!/bin/bash

# AI-Assisted Phase Transition Workflow
# Guides transitions between project lifecycle phases with methodology consistency

echo "🔄 AI-Assisted Phase Transition"
echo "==============================="
echo ""

# Check parameters
if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Usage: ./workflows/phase-transition.sh [from_phase] [to_phase]"
    echo ""
    echo "Available phases:"
    echo "  0 - conception"
    echo "  1 - technology-selection"
    echo "  2 - project-setup"
    echo "  3 - design-architecture"
    echo "  4 - core-development"
    echo "  5 - quality-assurance"
    echo "  6 - deployment-preparation"
    echo "  7 - maintenance-evolution"
    echo ""
    echo "Example: ./workflows/phase-transition.sh 0 1"
    exit 1
fi

FROM_PHASE=$1
TO_PHASE=$2
PROJECT_CONFIG=".project-config/methodology.json"

# Phase name mapping
declare -A PHASE_NAMES
PHASE_NAMES[0]="conception"
PHASE_NAMES[1]="technology-selection"
PHASE_NAMES[2]="project-setup"
PHASE_NAMES[3]="design-architecture"
PHASE_NAMES[4]="core-development"
PHASE_NAMES[5]="quality-assurance"
PHASE_NAMES[6]="deployment-preparation"
PHASE_NAMES[7]="maintenance-evolution"

FROM_NAME=${PHASE_NAMES[$FROM_PHASE]}
TO_NAME=${PHASE_NAMES[$TO_PHASE]}

# Validate phases
if [ -z "$FROM_NAME" ] || [ -z "$TO_NAME" ]; then
    echo "❌ Invalid phase numbers. Use 0-7."
    exit 1
fi

# Check if project is configured
if [ ! -f "$PROJECT_CONFIG" ]; then
    echo "❌ Project not configured. Run ./workflows/methodology-selection.sh first"
    exit 1
fi

# Load project configuration
PROJECT_NAME=$(jq -r '.project_name // "Unknown Project"' "$PROJECT_CONFIG" 2>/dev/null || echo "Unknown Project")
METHODOLOGY=$(jq -r '.primary_methodology' "$PROJECT_CONFIG" 2>/dev/null || echo "unknown")

echo "Project: $PROJECT_NAME"
echo "Methodology: $METHODOLOGY"
echo "Transition: Phase $FROM_PHASE ($FROM_NAME) → Phase $TO_PHASE ($TO_NAME)"
echo ""

# Phase transition validation
echo "📋 Phase $FROM_PHASE Completion Validation"
echo "=========================================="
echo ""

case $FROM_PHASE in
    0) # Conception
        echo "Conception Phase Completion Checklist:"
        echo "- [ ] Problem definition is validated and documented"
        echo "- [ ] Solution approach is defined and feasible"
        echo "- [ ] $METHODOLOGY success criteria are established"
        echo "- [ ] Project scope and constraints are clear"
        echo "- [ ] Stakeholder alignment is achieved"
        echo "- [ ] Technology requirements are identified"
        ;;
    1) # Technology Selection
        echo "Technology Selection Phase Completion Checklist:"
        echo "- [ ] Technology stack is selected and documented"
        echo "- [ ] Architecture decisions are recorded (ADRs)"
        echo "- [ ] $METHODOLOGY technology criteria are satisfied"
        echo "- [ ] Technology integration is validated"
        echo "- [ ] Development environment requirements are defined"
        ;;
    2) # Project Setup
        echo "Project Setup Phase Completion Checklist:"
        echo "- [ ] Development environment is configured"
        echo "- [ ] Project structure is established"
        echo "- [ ] CI/CD pipeline is set up"
        echo "- [ ] $METHODOLOGY development workflow is configured"
        echo "- [ ] Quality gates and standards are established"
        ;;
    3) # Design & Architecture
        echo "Design & Architecture Phase Completion Checklist:"
        echo "- [ ] System architecture is designed and documented"
        echo "- [ ] User interface design is completed"
        echo "- [ ] Database schema is designed"
        echo "- [ ] API specifications are defined"
        echo "- [ ] $METHODOLOGY design principles are implemented"
        ;;
    4) # Core Development
        echo "Core Development Phase Completion Checklist:"
        echo "- [ ] All core features are implemented"
        echo "- [ ] Code quality standards are met"
        echo "- [ ] Testing suite is comprehensive"
        echo "- [ ] $METHODOLOGY success criteria are achieved"
        echo "- [ ] Documentation is complete and current"
        ;;
    5) # Quality Assurance
        echo "Quality Assurance Phase Completion Checklist:"
        echo "- [ ] All testing is complete and passing"
        echo "- [ ] $METHODOLOGY quality standards are validated"
        echo "- [ ] Performance requirements are met"
        echo "- [ ] Security and compliance are verified"
        echo "- [ ] User acceptance testing is complete"
        ;;
    6) # Deployment Preparation
        echo "Deployment Preparation Phase Completion Checklist:"
        echo "- [ ] Production environment is configured"
        echo "- [ ] Deployment procedures are tested"
        echo "- [ ] Monitoring and logging are set up"
        echo "- [ ] $METHODOLOGY deployment criteria are met"
        echo "- [ ] Rollback procedures are prepared"
        ;;
esac

echo ""
read -p "Have you completed all items above? (y/n): " PHASE_COMPLETE

if [[ ! $PHASE_COMPLETE =~ ^[Yy]$ ]]; then
    echo ""
    echo "⚠️  Please complete Phase $FROM_PHASE before transitioning to Phase $TO_PHASE"
    echo "Use the checklist above to ensure all deliverables are ready."
    exit 1
fi

# Phase transition preparation
echo ""
echo "🎯 Phase $TO_PHASE Preparation"
echo "=============================="
echo ""

case $TO_PHASE in
    1) # Technology Selection
        echo "Preparing for Technology Selection Phase:"
        echo ""
        echo "Required inputs from Conception:"
        echo "- Problem definition and solution approach"
        echo "- Technology requirements and constraints"
        echo "- $METHODOLOGY evaluation criteria"
        echo "- Performance and scalability requirements"
        echo ""
        echo "AI Assistance Prompt for Technology Selection:"
        cat << EOF
I'm transitioning from Conception to Technology Selection for "$PROJECT_NAME" using $METHODOLOGY methodology.

Conception Phase Outputs:
- Problem: [Paste problem definition]
- Solution: [Paste solution approach]
- Requirements: [Paste technology requirements]

Help me select technologies that align with $METHODOLOGY methodology:
1. Evaluate technology options against $METHODOLOGY criteria
2. Recommend technology stack based on requirements
3. Assess technology integration and compatibility
4. Plan technology validation and proof-of-concept
5. Create technology selection decision framework

Focus on $METHODOLOGY priorities and success criteria.
EOF
        ;;
    2) # Project Setup
        echo "Preparing for Project Setup Phase:"
        echo ""
        echo "Required inputs from Technology Selection:"
        echo "- Selected technology stack"
        echo "- Architecture decision records (ADRs)"
        echo "- Development tool requirements"
        echo "- Integration and deployment needs"
        echo ""
        echo "AI Assistance Prompt for Project Setup:"
        cat << EOF
I'm transitioning from Technology Selection to Project Setup for "$PROJECT_NAME" using $METHODOLOGY methodology.

Technology Selection Outputs:
- Technology Stack: [Paste selected technologies]
- ADRs: [Paste key architecture decisions]
- Requirements: [Paste development requirements]

Help me set up the project environment aligned with $METHODOLOGY methodology:
1. Configure development environment for $METHODOLOGY workflow
2. Set up project structure and organization
3. Configure CI/CD pipeline and quality gates
4. Establish $METHODOLOGY-specific development practices
5. Plan team workflow and collaboration tools

Focus on $METHODOLOGY development efficiency and quality standards.
EOF
        ;;
    3) # Design & Architecture
        echo "Preparing for Design & Architecture Phase:"
        echo ""
        echo "Required inputs from Project Setup:"
        echo "- Configured development environment"
        echo "- Project structure and organization"
        echo "- Development workflow and standards"
        echo "- Quality gates and validation procedures"
        echo ""
        echo "AI Assistance Prompt for Design & Architecture:"
        cat << EOF
I'm transitioning from Project Setup to Design & Architecture for "$PROJECT_NAME" using $METHODOLOGY methodology.

Project Setup Outputs:
- Environment: [Paste environment configuration]
- Structure: [Paste project organization]
- Workflow: [Paste development workflow]

Help me design the system architecture aligned with $METHODOLOGY methodology:
1. Design system architecture based on $METHODOLOGY principles
2. Create user interface and interaction design
3. Design database schema and data architecture
4. Define API specifications and integration points
5. Plan $METHODOLOGY-specific design validation

Focus on $METHODOLOGY design priorities and success criteria.
EOF
        ;;
    4) # Core Development
        echo "Preparing for Core Development Phase:"
        echo ""
        echo "Required inputs from Design & Architecture:"
        echo "- System architecture and design specifications"
        echo "- User interface and interaction design"
        echo "- Database schema and data models"
        echo "- API specifications and contracts"
        echo ""
        echo "AI Assistance Prompt for Core Development:"
        cat << EOF
I'm transitioning from Design & Architecture to Core Development for "$PROJECT_NAME" using $METHODOLOGY methodology.

Design & Architecture Outputs:
- Architecture: [Paste system architecture]
- UI Design: [Paste interface specifications]
- Database: [Paste schema design]
- APIs: [Paste API specifications]

Help me plan the development implementation aligned with $METHODOLOGY methodology:
1. Plan feature implementation based on $METHODOLOGY priorities
2. Define development workflow and quality standards
3. Establish $METHODOLOGY-specific validation checkpoints
4. Plan testing strategy and quality assurance
5. Create implementation timeline and milestones

Focus on $METHODOLOGY development approach and success metrics.
EOF
        ;;
    5) # Quality Assurance
        echo "Preparing for Quality Assurance Phase:"
        echo ""
        echo "Required inputs from Core Development:"
        echo "- Complete feature implementations"
        echo "- Comprehensive test suite"
        echo "- Code quality metrics and analysis"
        echo "- Performance benchmarks and results"
        echo ""
        echo "AI Assistance Prompt for Quality Assurance:"
        cat << EOF
I'm transitioning from Core Development to Quality Assurance for "$PROJECT_NAME" using $METHODOLOGY methodology.

Core Development Outputs:
- Features: [Paste implemented features]
- Tests: [Paste test coverage and results]
- Quality: [Paste code quality metrics]
- Performance: [Paste performance results]

Help me plan quality assurance aligned with $METHODOLOGY methodology:
1. Define $METHODOLOGY-specific quality criteria and standards
2. Plan comprehensive testing strategy and validation
3. Establish quality gates and acceptance criteria
4. Plan $METHODOLOGY-specific validation procedures
5. Create quality assurance timeline and checkpoints

Focus on $METHODOLOGY quality standards and success validation.
EOF
        ;;
    6) # Deployment Preparation
        echo "Preparing for Deployment Preparation Phase:"
        echo ""
        echo "Required inputs from Quality Assurance:"
        echo "- Validated quality and testing results"
        echo "- Performance and security validation"
        echo "- User acceptance testing completion"
        echo "- $METHODOLOGY success criteria validation"
        echo ""
        echo "AI Assistance Prompt for Deployment Preparation:"
        cat << EOF
I'm transitioning from Quality Assurance to Deployment Preparation for "$PROJECT_NAME" using $METHODOLOGY methodology.

Quality Assurance Outputs:
- Quality Results: [Paste QA validation results]
- Testing: [Paste test completion status]
- Performance: [Paste performance validation]
- Acceptance: [Paste user acceptance results]

Help me prepare for deployment aligned with $METHODOLOGY methodology:
1. Plan production environment configuration
2. Design deployment strategy and procedures
3. Set up monitoring and observability
4. Plan $METHODOLOGY-specific deployment validation
5. Create rollback and recovery procedures

Focus on $METHODOLOGY deployment priorities and success criteria.
EOF
        ;;
    7) # Maintenance & Evolution
        echo "Preparing for Maintenance & Evolution Phase:"
        echo ""
        echo "Required inputs from Deployment Preparation:"
        echo "- Production-ready deployment configuration"
        echo "- Monitoring and observability setup"
        echo "- Deployment procedures and validation"
        echo "- Rollback and recovery procedures"
        echo ""
        echo "AI Assistance Prompt for Maintenance & Evolution:"
        cat << EOF
I'm transitioning from Deployment Preparation to Maintenance & Evolution for "$PROJECT_NAME" using $METHODOLOGY methodology.

Deployment Preparation Outputs:
- Production Config: [Paste deployment configuration]
- Monitoring: [Paste observability setup]
- Procedures: [Paste deployment procedures]

Help me plan long-term maintenance and evolution aligned with $METHODOLOGY methodology:
1. Plan $METHODOLOGY-specific maintenance approach
2. Design evolution and improvement strategy
3. Set up continuous monitoring and optimization
4. Plan $METHODOLOGY-focused enhancement cycles
5. Create long-term success measurement framework

Focus on $METHODOLOGY long-term success and continuous improvement.
EOF
        ;;
esac

echo ""
echo "📁 Phase $TO_PHASE Template Setup"
echo "================================="
echo ""

# Copy phase template
PHASE_TEMPLATE="project-lifecycle/0${TO_PHASE}-${TO_NAME}/phase-template.md"
PHASE_INSTANCE="docs/phases/phase-${TO_PHASE}-${TO_NAME}.md"

mkdir -p docs/phases

if [ -f "$PHASE_TEMPLATE" ]; then
    cp "$PHASE_TEMPLATE" "$PHASE_INSTANCE"
    
    # Replace template variables
    sed -i "s/{{PROJECT_NAME}}/$PROJECT_NAME/g" "$PHASE_INSTANCE"
    sed -i "s/{{METHODOLOGY}}/$METHODOLOGY/g" "$PHASE_INSTANCE"
    sed -i "s/{{DATE}}/$(date +%Y-%m-%d)/g" "$PHASE_INSTANCE"
    
    echo "✅ Phase $TO_PHASE template created: $PHASE_INSTANCE"
else
    echo "⚠️  Phase template not found: $PHASE_TEMPLATE"
fi

# Update project configuration
jq ". + {\"current_phase\": $TO_PHASE, \"phase_transition_date\": \"$(date -u +%Y-%m-%dT%H:%M:%SZ)\"}" "$PROJECT_CONFIG" > "$PROJECT_CONFIG.tmp" && mv "$PROJECT_CONFIG.tmp" "$PROJECT_CONFIG"

echo ""
echo "🎯 Next Steps"
echo "============="
echo "1. Review the Phase $TO_PHASE template: $PHASE_INSTANCE"
echo "2. Use the AI assistance prompt above to plan the phase"
echo "3. Follow the $METHODOLOGY methodology guidelines"
echo "4. Complete Phase $TO_PHASE deliverables and validation"
echo "5. Run phase transition again when ready for the next phase"
echo ""

echo "✅ Phase transition complete!"
echo "📊 Current Phase: $TO_PHASE ($TO_NAME)"
