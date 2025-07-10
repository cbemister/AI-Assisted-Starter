# Methodology Selection Decision Tree

## Quick Selection Guide (2 minutes)

### Primary Question: What drives your project success?

```
What is your main success criteria?
├── User satisfaction & accessibility → USER-CENTRIC
├── Technical performance & innovation → TECHNOLOGY-INNOVATION
└── Business outcomes & ROI → BUSINESS-VALUE
```

### Detailed Decision Tree

#### Level 1: Project Type Assessment
```
What type of application are you building?
├── Consumer App (B2C)
│   ├── User experience critical → USER-CENTRIC
│   ├── Performance critical → TECHNOLOGY-INNOVATION
│   └── Monetization focused → BUSINESS-VALUE
├── Technical Product (B2B)
│   ├── Usability important → USER-CENTRIC
│   ├── Technical capabilities → TECHNOLOGY-INNOVATION
│   └── Business efficiency → BUSINESS-VALUE
└── Internal Tool
    ├── Employee experience → USER-CENTRIC
    ├── System performance → TECHNOLOGY-INNOVATION
    └── Cost reduction → BUSINESS-VALUE
```

#### Level 2: Competitive Advantage
```
What is your main competitive advantage?
├── Superior UX/Accessibility
│   └── → USER-CENTRIC
├── Technical Innovation/Performance
│   └── → TECHNOLOGY-INNOVATION
└── Business Value/Cost Efficiency
    └── → BUSINESS-VALUE
```

#### Level 3: Quality Measurement
```
How do you measure success?
├── User Metrics (satisfaction, task completion, accessibility)
│   └── → USER-CENTRIC
├── Technical Metrics (performance, innovation, benchmarks)
│   └── → TECHNOLOGY-INNOVATION
└── Business Metrics (ROI, KPIs, stakeholder satisfaction)
    └── → BUSINESS-VALUE
```

## Methodology Profiles

### 👥 User-Centric Methodology
**Choose when:**
- User experience is your primary differentiator
- Accessibility compliance is required or important
- User feedback and satisfaction drive success
- Building consumer-facing applications
- User task completion is critical

**Evaluation Focus:**
- User Experience Quality (40%)
- Accessibility Compliance (30%)
- User Feedback Integration (20%)
- User Performance Impact (10%)

**Success Metrics:**
- User satisfaction scores
- Accessibility compliance rates
- User task completion rates
- User adoption and retention

### 🚀 Technology-Innovation Methodology
**Choose when:**
- Technical performance is your competitive advantage
- Innovation and cutting-edge technology matter
- Technical excellence drives market position
- Building performance-critical applications
- Technical capabilities differentiate your product

**Evaluation Focus:**
- Technical Innovation Level (40%)
- Performance Optimization (25%)
- Code Quality & Excellence (20%)
- Technology Integration (15%)

**Success Metrics:**
- Performance benchmarks
- Technical innovation adoption
- Code quality metrics
- Competitive technical advantages

### 💰 Business-Value Methodology
**Choose when:**
- Business outcomes and ROI are primary goals
- Cost optimization and efficiency matter most
- Stakeholder satisfaction drives decisions
- Building business tools or revenue-generating products
- Measurable business impact is required

**Evaluation Focus:**
- Business Value Delivery (40%)
- Cost Effectiveness (25%)
- Stakeholder Satisfaction (20%)
- Operational Efficiency (15%)

**Success Metrics:**
- Business KPI achievement
- Return on investment
- Stakeholder satisfaction
- Cost optimization

## Hybrid Approaches

### When to Use Hybrid
Consider combining methodologies when:
- Scores are within 2 points of each other
- Project has multiple critical success factors
- Different phases require different focus areas
- Stakeholders have diverse priorities

### Common Hybrid Combinations

#### User-Centric + Technology-Innovation
**Best for:** Consumer apps requiring both great UX and performance
- Primary: User-Centric (70%)
- Secondary: Technology-Innovation (30%)
- Focus: Exceptional user experience with technical excellence

#### Technology-Innovation + Business-Value
**Best for:** Technical products with clear business objectives
- Primary: Technology-Innovation (70%)
- Secondary: Business-Value (30%)
- Focus: Technical leadership with business impact

#### Business-Value + User-Centric
**Best for:** Business tools where user adoption drives value
- Primary: Business-Value (70%)
- Secondary: User-Centric (30%)
- Focus: Business outcomes with user experience consideration

## Phase-Specific Methodology Selection

### Different Methodologies by Phase
Some projects benefit from methodology shifts across phases:

```
Phase 0-1: Business-Value (validate market opportunity)
Phase 2-3: Technology-Innovation (build technical foundation)
Phase 4-7: User-Centric (optimize user experience)
```

### Methodology Transition Points
Consider methodology changes at:
- **Phase 1 → 2**: After technology selection
- **Phase 3 → 4**: After architecture design
- **Phase 5 → 6**: After quality validation
- **Phase 7 → 8**: After deployment

## Selection Validation

### Methodology Alignment Check
Validate your selection by asking:

1. **Does this methodology align with your success criteria?**
2. **Will this approach satisfy your primary stakeholders?**
3. **Does this methodology support your competitive strategy?**
4. **Can you measure success using this methodology's metrics?**
5. **Do you have the skills/resources for this approach?**

### Red Flags
Reconsider your selection if:
- ❌ Methodology doesn't match your success definition
- ❌ You can't measure progress using methodology metrics
- ❌ Stakeholders won't value methodology outcomes
- ❌ You lack resources for methodology requirements
- ❌ Methodology conflicts with project constraints

## Implementation Guidelines

### Getting Started
1. **Run the selection wizard**: `./workflows/methodology-selection.sh`
2. **Review methodology modules**: `./methodologies/[your-choice]/`
3. **Configure templates**: Update placeholders with your methodology
4. **Set up AI prompts**: Use methodology-specific prompts
5. **Begin Phase 0**: Start with conception using your chosen approach

### Maintaining Consistency
- Reference methodology configuration in all decisions
- Use methodology-specific evaluation criteria
- Apply methodology principles to all phases
- Validate deliverables against methodology success metrics
- Document methodology-driven decisions

### Course Correction
If methodology isn't working:
1. **Assess why**: What's not working and why?
2. **Consider hybrid**: Add secondary methodology elements
3. **Phase transition**: Change methodology for remaining phases
4. **Full switch**: Re-run selection wizard if needed

---

**Next Steps:**
1. Use this decision tree to select your methodology
2. Run `./workflows/methodology-selection.sh` for interactive selection
3. Configure your project with chosen methodology
4. Begin development following methodology-specific workflows
