#!/bin/bash

# AI-Assisted Completion Strategy Generator
# Generates customized completion strategy documents from the template

echo "🎯 AI-Assisted Completion Strategy Generator"
echo "==========================================="
echo ""

# Function to display usage
show_usage() {
    echo "Usage: ./workflows/generate-completion-strategy.sh [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --project-name NAME        Project name (required)"
    echo "  --methodology METHOD       Methodology: user-centric, technology-innovation, business-value (required)"
    echo "  --project-domain DOMAIN    Project domain (e.g., e-commerce, healthcare, fintech)"
    echo "  --project-type TYPE        Project type (platform, application, system, service)"
    echo "  --phase-range RANGE        Phase range (e.g., 3-7)"
    echo "  --document-count COUNT     Number of remaining documents"
    echo "  --output-dir DIR           Output directory (default: development/planning/)"
    echo "  --help                     Show this help message"
    echo ""
    echo "Examples:"
    echo "  ./workflows/generate-completion-strategy.sh --project-name \"ShopFlow\" --methodology \"business-value\" --project-domain \"e-commerce\""
    echo "  ./workflows/generate-completion-strategy.sh --project-name \"MedFlow\" --methodology \"user-centric\" --project-domain \"healthcare\" --phase-range \"2-6\""
    echo ""
}

# Initialize variables
PROJECT_NAME=""
METHODOLOGY=""
PROJECT_DOMAIN=""
PROJECT_TYPE="application"
PHASE_RANGE="3-7"
DOCUMENT_COUNT="50"
OUTPUT_DIR="development/planning"
TEMPLATE_FILE="templates/completion-strategy-template.md"

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --project-name)
            PROJECT_NAME="$2"
            shift 2
            ;;
        --methodology)
            METHODOLOGY="$2"
            shift 2
            ;;
        --project-domain)
            PROJECT_DOMAIN="$2"
            shift 2
            ;;
        --project-type)
            PROJECT_TYPE="$2"
            shift 2
            ;;
        --phase-range)
            PHASE_RANGE="$2"
            shift 2
            ;;
        --document-count)
            DOCUMENT_COUNT="$2"
            shift 2
            ;;
        --output-dir)
            OUTPUT_DIR="$2"
            shift 2
            ;;
        --help)
            show_usage
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            show_usage
            exit 1
            ;;
    esac
done

# Validate required parameters
if [ -z "$PROJECT_NAME" ]; then
    echo "❌ Error: --project-name is required"
    show_usage
    exit 1
fi

if [ -z "$METHODOLOGY" ]; then
    echo "❌ Error: --methodology is required"
    show_usage
    exit 1
fi

# Validate methodology
case $METHODOLOGY in
    user-centric|technology-innovation|business-value)
        ;;
    *)
        echo "❌ Error: Invalid methodology. Must be one of: user-centric, technology-innovation, business-value"
        exit 1
        ;;
esac

# Check if template file exists
if [ ! -f "$TEMPLATE_FILE" ]; then
    echo "❌ Error: Template file not found: $TEMPLATE_FILE"
    exit 1
fi

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Generate output filename
OUTPUT_FILE="$OUTPUT_DIR/COMPLETION-STRATEGY.md"

echo "📝 Generating completion strategy..."
echo "Project Name: $PROJECT_NAME"
echo "Methodology: $METHODOLOGY"
echo "Project Domain: $PROJECT_DOMAIN"
echo "Project Type: $PROJECT_TYPE"
echo "Phase Range: $PHASE_RANGE"
echo "Document Count: $DOCUMENT_COUNT"
echo "Output File: $OUTPUT_FILE"
echo ""

# Copy template and perform variable substitution
cp "$TEMPLATE_FILE" "$OUTPUT_FILE"

# Basic variable substitutions
sed -i "s/{{PROJECT_NAME}}/$PROJECT_NAME/g" "$OUTPUT_FILE"
sed -i "s/{{METHODOLOGY}}/$METHODOLOGY/g" "$OUTPUT_FILE"
sed -i "s/{{PROJECT_DOMAIN}}/$PROJECT_DOMAIN/g" "$OUTPUT_FILE"
sed -i "s/{{PROJECT_TYPE}}/$PROJECT_TYPE/g" "$OUTPUT_FILE"
sed -i "s/{{PHASE_RANGE}}/$PHASE_RANGE/g" "$OUTPUT_FILE"
sed -i "s/{{REMAINING_DOCUMENT_COUNT}}/$DOCUMENT_COUNT/g" "$OUTPUT_FILE"

# Set methodology-specific variables
case $METHODOLOGY in
    user-centric)
        METHODOLOGY_FOCUS="User experience and accessibility"
        PRIMARY_GOAL="Exceptional user satisfaction and inclusive design"
        KEY_METRICS="User satisfaction scores, accessibility compliance, usability benchmarks"
        ;;
    technology-innovation)
        METHODOLOGY_FOCUS="Technical excellence and innovation"
        PRIMARY_GOAL="Cutting-edge technical implementation and performance"
        KEY_METRICS="Performance benchmarks, technical innovation adoption, code quality metrics"
        ;;
    business-value)
        METHODOLOGY_FOCUS="Business outcomes and ROI"
        PRIMARY_GOAL="Measurable business value and stakeholder satisfaction"
        KEY_METRICS="Business KPI achievement, cost-benefit ratios, ROI metrics"
        ;;
esac

sed -i "s/{{METHODOLOGY_FOCUS_AREAS}}/$METHODOLOGY_FOCUS/g" "$OUTPUT_FILE"
sed -i "s/{{PRIMARY_BUSINESS_GOAL}}/$PRIMARY_GOAL/g" "$OUTPUT_FILE"
sed -i "s/{{KEY_METRICS}}/$KEY_METRICS/g" "$OUTPUT_FILE"

# Set domain-specific variables
case $PROJECT_DOMAIN in
    e-commerce)
        PROJECT_FOCUS="online retail and customer experience"
        INTEGRATION_1="Payment gateway"
        INTEGRATION_2="Inventory management"
        INTEGRATION_3="Customer analytics"
        COMPLIANCE_TYPE="PCI DSS and data privacy"
        ;;
    healthcare)
        PROJECT_FOCUS="patient care and clinical workflows"
        INTEGRATION_1="Electronic Health Records (EHR)"
        INTEGRATION_2="Appointment scheduling"
        INTEGRATION_3="Insurance verification"
        COMPLIANCE_TYPE="HIPAA and medical device"
        ;;
    fintech)
        PROJECT_FOCUS="financial services and trading"
        INTEGRATION_1="Banking APIs"
        INTEGRATION_2="Payment processing"
        INTEGRATION_3="KYC/AML verification"
        COMPLIANCE_TYPE="Financial regulatory"
        ;;
    *)
        PROJECT_FOCUS="$PROJECT_DOMAIN automation"
        INTEGRATION_1="External API"
        INTEGRATION_2="Data processing"
        INTEGRATION_3="Analytics platform"
        COMPLIANCE_TYPE="Industry-specific"
        ;;
esac

sed -i "s/{{PROJECT_FOCUS}}/$PROJECT_FOCUS/g" "$OUTPUT_FILE"
sed -i "s/{{INTEGRATION_1}}/$INTEGRATION_1/g" "$OUTPUT_FILE"
sed -i "s/{{INTEGRATION_2}}/$INTEGRATION_2/g" "$OUTPUT_FILE"
sed -i "s/{{INTEGRATION_3}}/$INTEGRATION_3/g" "$OUTPUT_FILE"
sed -i "s/{{COMPLIANCE_TYPE}}/$COMPLIANCE_TYPE/g" "$OUTPUT_FILE"

# Set current date
CURRENT_DATE=$(date +%Y-%m-%d)
sed -i "s/{{LAST_UPDATED_DATE}}/$CURRENT_DATE/g" "$OUTPUT_FILE"

# Set default values for remaining variables
sed -i "s/{{STANDARD_DURATION}}/45-60 minutes/g" "$OUTPUT_FILE"
sed -i "s/{{ROADMAP_SOURCE}}/ROADMAP.md/g" "$OUTPUT_FILE"
sed -i "s/{{DOCUMENT_LOCATION}}/development\/planning\//g" "$OUTPUT_FILE"
sed -i "s/{{DELIVERABLE_COUNT}}/5/g" "$OUTPUT_FILE"
sed -i "s/{{FUNCTIONAL_REQ_COUNT}}/3/g" "$OUTPUT_FILE"
sed -i "s/{{NON_FUNCTIONAL_REQ_COUNT}}/3/g" "$OUTPUT_FILE"
sed -i "s/{{SUCCESS_CRITERIA_COUNT}}/3/g" "$OUTPUT_FILE"
sed -i "s/{{UNIVERSAL_CRITERIA_COUNT}}/3/g" "$OUTPUT_FILE"
sed -i "s/{{ACCEPTANCE_CRITERIA_COUNT}}/5/g" "$OUTPUT_FILE"
sed -i "s/{{RISK_COUNT}}/3/g" "$OUTPUT_FILE"

echo "✅ Completion strategy generated successfully!"
echo "📄 File created: $OUTPUT_FILE"
echo ""
echo "🎯 Next Steps:"
echo "1. Review and customize the generated completion strategy"
echo "2. Update phase-specific sections with your project details"
echo "3. Customize the document lists for each phase"
echo "4. Begin systematic document creation using the strategy"
echo ""
echo "💡 Tip: Use this completion strategy with the feature planning template:"
echo "   templates/feature-planning-template.md"
echo ""
