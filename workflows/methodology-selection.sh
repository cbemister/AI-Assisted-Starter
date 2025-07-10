#!/bin/bash

# AI-Assisted Methodology Selection Wizard
# Helps solo developers choose the optimal development philosophy

echo "🎯 AI-Assisted Development Methodology Selection"
echo "=============================================="
echo ""
echo "This wizard will help you select the optimal development methodology"
echo "based on your project goals and priorities."
echo ""

# Initialize variables
USER_CENTRIC_SCORE=0
TECH_INNOVATION_SCORE=0
BUSINESS_VALUE_SCORE=0

# Question 1: Primary Success Criteria
echo "Question 1: What is your primary definition of project success?"
echo ""
echo "A) High user satisfaction and accessibility compliance"
echo "B) Technical performance excellence and innovation recognition"
echo "C) Measurable business outcomes and return on investment"
echo ""
read -p "Enter your choice (A/B/C): " Q1

case $Q1 in
    [Aa]) USER_CENTRIC_SCORE=$((USER_CENTRIC_SCORE + 3)) ;;
    [Bb]) TECH_INNOVATION_SCORE=$((TECH_INNOVATION_SCORE + 3)) ;;
    [Cc]) BUSINESS_VALUE_SCORE=$((BUSINESS_VALUE_SCORE + 3)) ;;
esac

# Question 2: Application Type
echo ""
echo "Question 2: What type of application are you building?"
echo ""
echo "A) Consumer-facing app where user experience is critical"
echo "B) Technical product where performance and capabilities matter most"
echo "C) Business tool focused on efficiency and productivity"
echo ""
read -p "Enter your choice (A/B/C): " Q2

case $Q2 in
    [Aa]) USER_CENTRIC_SCORE=$((USER_CENTRIC_SCORE + 3)) ;;
    [Bb]) TECH_INNOVATION_SCORE=$((TECH_INNOVATION_SCORE + 3)) ;;
    [Cc]) BUSINESS_VALUE_SCORE=$((BUSINESS_VALUE_SCORE + 3)) ;;
esac

# Question 3: Competitive Advantage
echo ""
echo "Question 3: What will be your main competitive advantage?"
echo ""
echo "A) Superior user experience and accessibility"
echo "B) Advanced technical capabilities and performance"
echo "C) Clear business value and cost-effectiveness"
echo ""
read -p "Enter your choice (A/B/C): " Q3

case $Q3 in
    [Aa]) USER_CENTRIC_SCORE=$((USER_CENTRIC_SCORE + 3)) ;;
    [Bb]) TECH_INNOVATION_SCORE=$((TECH_INNOVATION_SCORE + 3)) ;;
    [Cc]) BUSINESS_VALUE_SCORE=$((BUSINESS_VALUE_SCORE + 3)) ;;
esac

# Question 4: Development Priorities
echo ""
echo "Question 4: Which development aspect is most important to you?"
echo ""
echo "A) User feedback integration and accessibility compliance"
echo "B) Technical excellence and cutting-edge implementation"
echo "C) Cost optimization and stakeholder satisfaction"
echo ""
read -p "Enter your choice (A/B/C): " Q4

case $Q4 in
    [Aa]) USER_CENTRIC_SCORE=$((USER_CENTRIC_SCORE + 2)) ;;
    [Bb]) TECH_INNOVATION_SCORE=$((TECH_INNOVATION_SCORE + 2)) ;;
    [Cc]) BUSINESS_VALUE_SCORE=$((BUSINESS_VALUE_SCORE + 2)) ;;
esac

# Question 5: Quality Measurement
echo ""
echo "Question 5: How do you want to measure quality?"
echo ""
echo "A) User satisfaction scores and task completion rates"
echo "B) Performance benchmarks and technical metrics"
echo "C) Business KPIs and return on investment"
echo ""
read -p "Enter your choice (A/B/C): " Q5

case $Q5 in
    [Aa]) USER_CENTRIC_SCORE=$((USER_CENTRIC_SCORE + 2)) ;;
    [Bb]) TECH_INNOVATION_SCORE=$((TECH_INNOVATION_SCORE + 2)) ;;
    [Cc]) BUSINESS_VALUE_SCORE=$((BUSINESS_VALUE_SCORE + 2)) ;;
esac

# Calculate results
echo ""
echo "📊 Calculating your methodology alignment..."
echo ""

# Determine primary methodology
PRIMARY_METHODOLOGY=""
HIGHEST_SCORE=0

if [ $USER_CENTRIC_SCORE -gt $HIGHEST_SCORE ]; then
    HIGHEST_SCORE=$USER_CENTRIC_SCORE
    PRIMARY_METHODOLOGY="user-centric"
fi

if [ $TECH_INNOVATION_SCORE -gt $HIGHEST_SCORE ]; then
    HIGHEST_SCORE=$TECH_INNOVATION_SCORE
    PRIMARY_METHODOLOGY="technology-innovation"
fi

if [ $BUSINESS_VALUE_SCORE -gt $HIGHEST_SCORE ]; then
    HIGHEST_SCORE=$BUSINESS_VALUE_SCORE
    PRIMARY_METHODOLOGY="business-value"
fi

# Display results
echo "🎯 METHODOLOGY SELECTION RESULTS"
echo "================================"
echo ""
echo "Scores:"
echo "👥 User-Centric: $USER_CENTRIC_SCORE points"
echo "🚀 Technology-Innovation: $TECH_INNOVATION_SCORE points"
echo "💰 Business-Value: $BUSINESS_VALUE_SCORE points"
echo ""

# Display recommendation
case $PRIMARY_METHODOLOGY in
    "user-centric")
        echo "🎯 RECOMMENDED: User-Centric Methodology"
        echo ""
        echo "Your project will benefit from focusing on:"
        echo "• User experience optimization and accessibility"
        echo "• User feedback integration and validation"
        echo "• Inclusive design and user satisfaction"
        echo "• User task completion and usability"
        echo ""
        echo "Success will be measured by user satisfaction scores,"
        echo "accessibility compliance, and user experience quality."
        ;;
    "technology-innovation")
        echo "🚀 RECOMMENDED: Technology-Innovation Methodology"
        echo ""
        echo "Your project will benefit from focusing on:"
        echo "• Technical performance and optimization"
        echo "• Cutting-edge technology adoption"
        echo "• Technical excellence and best practices"
        echo "• Innovation and competitive technical advantages"
        echo ""
        echo "Success will be measured by performance benchmarks,"
        echo "technical innovation, and competitive advantages."
        ;;
    "business-value")
        echo "💰 RECOMMENDED: Business-Value Methodology"
        echo ""
        echo "Your project will benefit from focusing on:"
        echo "• Business objective achievement and ROI"
        echo "• Cost optimization and efficiency"
        echo "• Stakeholder satisfaction and requirements"
        echo "• Measurable business outcomes"
        echo ""
        echo "Success will be measured by business KPIs,"
        echo "return on investment, and stakeholder satisfaction."
        ;;
esac

# Check for close scores (hybrid approach)
SECOND_HIGHEST=0
SECONDARY_METHODOLOGY=""

# Find second highest score
if [ $USER_CENTRIC_SCORE -ne $HIGHEST_SCORE ] && [ $USER_CENTRIC_SCORE -gt $SECOND_HIGHEST ]; then
    SECOND_HIGHEST=$USER_CENTRIC_SCORE
    SECONDARY_METHODOLOGY="user-centric"
fi

if [ $TECH_INNOVATION_SCORE -ne $HIGHEST_SCORE ] && [ $TECH_INNOVATION_SCORE -gt $SECOND_HIGHEST ]; then
    SECOND_HIGHEST=$TECH_INNOVATION_SCORE
    SECONDARY_METHODOLOGY="technology-innovation"
fi

if [ $BUSINESS_VALUE_SCORE -ne $HIGHEST_SCORE ] && [ $BUSINESS_VALUE_SCORE -gt $SECOND_HIGHEST ]; then
    SECOND_HIGHEST=$BUSINESS_VALUE_SCORE
    SECONDARY_METHODOLOGY="business-value"
fi

# Suggest hybrid approach if scores are close
SCORE_DIFFERENCE=$((HIGHEST_SCORE - SECOND_HIGHEST))
if [ $SCORE_DIFFERENCE -le 2 ]; then
    echo ""
    echo "💡 HYBRID APPROACH SUGGESTED"
    echo "Your scores are close. Consider a hybrid approach:"
    echo "• Primary: $PRIMARY_METHODOLOGY (70% of decisions)"
    echo "• Secondary: $SECONDARY_METHODOLOGY (30% of decisions)"
    echo ""
    echo "This allows you to focus on your primary methodology while"
    echo "incorporating important aspects of the secondary approach."
fi

# Save selection to project configuration
echo ""
read -p "Do you want to configure your project with this methodology? (y/n): " CONFIGURE

if [[ $CONFIGURE =~ ^[Yy]$ ]]; then
    # Create project configuration
    mkdir -p .project-config
    
    cat > .project-config/methodology.json << EOF
{
  "primary_methodology": "$PRIMARY_METHODOLOGY",
  "secondary_methodology": "$SECONDARY_METHODOLOGY",
  "scores": {
    "user_centric": $USER_CENTRIC_SCORE,
    "technology_innovation": $TECH_INNOVATION_SCORE,
    "business_value": $BUSINESS_VALUE_SCORE
  },
  "hybrid_approach": $([ $SCORE_DIFFERENCE -le 2 ] && echo "true" || echo "false"),
  "selection_date": "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
}
EOF

    echo ""
    echo "✅ Project configured with $PRIMARY_METHODOLOGY methodology"
    echo ""
    echo "Next steps:"
    echo "1. Run: ./workflows/generate-prd.sh $PRIMARY_METHODOLOGY"
    echo "2. Begin Phase 0 (Conception) with your chosen methodology"
    echo "3. Use AI prompts from: ./ai-prompts/conception/$PRIMARY_METHODOLOGY/"
    echo ""
    echo "Your methodology configuration has been saved to:"
    echo ".project-config/methodology.json"
else
    echo ""
    echo "Configuration skipped. You can run this wizard again anytime:"
    echo "./workflows/methodology-selection.sh"
fi

echo ""
echo "🎯 Methodology selection complete!"
echo "Refer to README.md for next steps and development workflows."
