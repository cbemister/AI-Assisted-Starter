#!/bin/bash

# AI-Assisted PRD Generation Workflow
# Generates a comprehensive Product Requirements Document using chosen methodology

echo "🎯 AI-Assisted PRD Generation"
echo "============================="
echo ""

# Check if methodology is provided
if [ -z "$1" ]; then
    echo "Usage: ./workflows/generate-prd.sh [methodology]"
    echo ""
    echo "Available methodologies:"
    echo "  user-centric"
    echo "  technology-innovation"
    echo "  business-value"
    echo ""
    exit 1
fi

METHODOLOGY=$1
PROJECT_CONFIG=".project-config/methodology.json"

# Validate methodology
case $METHODOLOGY in
    "user-centric"|"technology-innovation"|"business-value")
        echo "✅ Using $METHODOLOGY methodology for PRD generation"
        ;;
    *)
        echo "❌ Invalid methodology: $METHODOLOGY"
        echo "Valid options: user-centric, technology-innovation, business-value"
        exit 1
        ;;
esac

# Check if project is configured
if [ ! -f "$PROJECT_CONFIG" ]; then
    echo "❌ Project not configured. Run ./workflows/methodology-selection.sh first"
    exit 1
fi

# Load project configuration
PROJECT_NAME=$(jq -r '.project_name // "Unknown Project"' "$PROJECT_CONFIG" 2>/dev/null || echo "Unknown Project")
PRIMARY_METHODOLOGY=$(jq -r '.primary_methodology' "$PROJECT_CONFIG" 2>/dev/null || echo "$METHODOLOGY")

echo ""
echo "Project: $PROJECT_NAME"
echo "Methodology: $PRIMARY_METHODOLOGY"
echo ""

# Create PRD directory if it doesn't exist
mkdir -p docs/requirements

# Generate PRD filename with timestamp
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
PRD_FILE="docs/requirements/PRD_${METHODOLOGY}_${TIMESTAMP}.md"

echo "📝 Generating PRD using $METHODOLOGY methodology..."
echo ""

# Copy and customize PRD template
cp "templates/prd-template.md" "$PRD_FILE"

# Replace template variables
sed -i "s/{{PROJECT_NAME}}/$PROJECT_NAME/g" "$PRD_FILE"
sed -i "s/{{METHODOLOGY}}/$METHODOLOGY/g" "$PRD_FILE"
sed -i "s/{{DATE}}/$(date +%Y-%m-%d)/g" "$PRD_FILE"

echo "✅ PRD template created: $PRD_FILE"
echo ""

# Provide AI assistance prompts for PRD completion
echo "🤖 AI Assistance for PRD Completion"
echo "===================================="
echo ""
echo "Use these AI prompts to complete your PRD:"
echo ""

case $METHODOLOGY in
    "user-centric")
        echo "1. PROBLEM DEFINITION PROMPT:"
        echo "----------------------------"
        cat << 'EOF'
I'm creating a PRD for "{{PROJECT_NAME}}" using User-Centric methodology.

Help me define the problem section by focusing on:
- User pain points and frustrations
- User task completion barriers
- Accessibility issues and compliance gaps
- User workflow inefficiencies
- User satisfaction and experience problems

Current context: [Paste your project context here]

Please provide:
1. User-centered problem statement
2. User impact analysis (frequency, severity, affected users)
3. Accessibility requirements and compliance needs
4. User validation approach and success criteria

Focus on user experience quality and inclusive design.
EOF
        ;;
    "technology-innovation")
        echo "1. PROBLEM DEFINITION PROMPT:"
        echo "----------------------------"
        cat << 'EOF'
I'm creating a PRD for "{{PROJECT_NAME}}" using Technology-Innovation methodology.

Help me define the problem section by focusing on:
- Technical limitations and performance bottlenecks
- Innovation opportunities and competitive advantages
- Technology gaps and advancement possibilities
- Technical differentiation and breakthrough potential
- Performance optimization and scalability challenges

Current context: [Paste your project context here]

Please provide:
1. Technology-focused problem statement
2. Technical innovation opportunities and competitive analysis
3. Performance requirements and optimization targets
4. Technology validation approach and success criteria

Focus on technical excellence and competitive technical advantages.
EOF
        ;;
    "business-value")
        echo "1. PROBLEM DEFINITION PROMPT:"
        echo "----------------------------"
        cat << 'EOF'
I'm creating a PRD for "{{PROJECT_NAME}}" using Business-Value methodology.

Help me define the problem section by focusing on:
- Business inefficiencies and cost impacts
- Revenue opportunities and market gaps
- Stakeholder pain points and business objectives
- Competitive positioning and market advantages
- ROI potential and business value creation

Current context: [Paste your project context here]

Please provide:
1. Business-focused problem statement
2. Financial impact analysis and market opportunity assessment
3. Business requirements and stakeholder needs
4. Business validation approach and success criteria

Focus on measurable business outcomes and return on investment.
EOF
        ;;
esac

echo ""
echo "2. SOLUTION APPROACH PROMPT:"
echo "---------------------------"
cat << EOF
Based on my problem definition for "$PROJECT_NAME" using $METHODOLOGY methodology:

[Paste your completed problem definition here]

Help me define the solution approach section:
1. High-level solution concept aligned with $METHODOLOGY principles
2. Key features and capabilities that address the core problem
3. Success criteria and measurement approach for $METHODOLOGY
4. Implementation approach and methodology-specific considerations
5. Risk assessment and mitigation strategies

Ensure the solution approach prioritizes $METHODOLOGY success factors.
EOF

echo ""
echo "3. REQUIREMENTS SPECIFICATION PROMPT:"
echo "------------------------------------"
cat << EOF
For "$PROJECT_NAME" using $METHODOLOGY methodology, help me specify detailed requirements:

Solution Approach: [Paste your solution approach here]

Generate detailed requirements covering:
1. Functional requirements aligned with $METHODOLOGY priorities
2. Non-functional requirements (performance, security, accessibility)
3. Technical requirements and constraints
4. User experience requirements (if applicable)
5. Business requirements and success metrics (if applicable)

Format as user stories or requirement statements with acceptance criteria.
Prioritize requirements based on $METHODOLOGY evaluation criteria.
EOF

echo ""
echo "4. TECHNICAL ARCHITECTURE PROMPT:"
echo "--------------------------------"
cat << EOF
For "$PROJECT_NAME" using $METHODOLOGY methodology, help me define the technical architecture:

Requirements: [Paste your requirements here]

Provide technical architecture recommendations:
1. System architecture aligned with $METHODOLOGY priorities
2. Technology stack recommendations based on $METHODOLOGY criteria
3. Data architecture and storage requirements
4. Integration requirements and API design
5. Security and compliance considerations
6. Performance and scalability architecture

Ensure architecture supports $METHODOLOGY success criteria and requirements.
EOF

echo ""
echo "📋 PRD Completion Checklist"
echo "==========================="
echo ""
echo "Complete these sections in your PRD:"
echo "- [ ] Executive Summary"
echo "- [ ] Problem Definition (using AI prompt #1)"
echo "- [ ] Solution Approach (using AI prompt #2)"
echo "- [ ] Requirements Specification (using AI prompt #3)"
echo "- [ ] Technical Architecture (using AI prompt #4)"
echo "- [ ] Success Metrics and Validation"
echo "- [ ] Timeline and Milestones"
echo "- [ ] Risk Assessment and Mitigation"
echo ""

case $METHODOLOGY in
    "user-centric")
        echo "User-Centric Specific Sections:"
        echo "- [ ] User Research and Personas"
        echo "- [ ] User Journey Maps and Workflows"
        echo "- [ ] Accessibility Requirements and Compliance"
        echo "- [ ] User Testing and Validation Plan"
        ;;
    "technology-innovation")
        echo "Technology-Innovation Specific Sections:"
        echo "- [ ] Technology Innovation Analysis"
        echo "- [ ] Performance Benchmarks and Targets"
        echo "- [ ] Competitive Technical Analysis"
        echo "- [ ] Technology Validation and Proof-of-Concept Plan"
        ;;
    "business-value")
        echo "Business-Value Specific Sections:"
        echo "- [ ] Business Case and ROI Analysis"
        echo "- [ ] Market Analysis and Competitive Positioning"
        echo "- [ ] Stakeholder Requirements and Approval"
        echo "- [ ] Business Validation and Success Measurement"
        ;;
esac

echo ""
echo "🎯 Next Steps"
echo "============="
echo "1. Open the PRD file: $PRD_FILE"
echo "2. Use the AI prompts above to complete each section"
echo "3. Validate the PRD against $METHODOLOGY criteria"
echo "4. Get stakeholder review and approval"
echo "5. Run: ./workflows/create-roadmap.sh $METHODOLOGY"
echo ""

# Update project configuration with PRD information
jq ". + {\"prd_file\": \"$PRD_FILE\", \"prd_generated\": \"$(date -u +%Y-%m-%dT%H:%M:%SZ)\"}" "$PROJECT_CONFIG" > "$PROJECT_CONFIG.tmp" && mv "$PROJECT_CONFIG.tmp" "$PROJECT_CONFIG"

echo "✅ PRD generation workflow complete!"
echo "📄 PRD file created: $PRD_FILE"
