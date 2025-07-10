# Concept A: {{CONCEPT_A_NAME}} Design
## {{APPLICATION_NAME}} {{APPLICATION_TYPE}}

### Design Philosophy
{{CONCEPT_A_PHILOSOPHY_DESCRIPTION}}. This concept prioritizes {{CONCEPT_A_PRIORITY_1}}, {{CONCEPT_A_PRIORITY_2}}, and {{CONCEPT_A_PRIORITY_3}} that {{CONCEPT_A_BENEFIT}}.

### Visual Identity
- **Personality**: {{CONCEPT_A_PERSONALITY_TRAITS}}
- **Aesthetic**: {{CONCEPT_A_AESTHETIC_DESCRIPTION}}
- **Target Feel**: {{CONCEPT_A_TARGET_FEEL}}

## Design System

### Color Palette
```css
/* design-tokens.css - Concept A Color Variables */
:root {
  /* Primary Colors */
  --color-primary-50: {{CONCEPT_A_PRIMARY_50}};
  --color-primary-100: {{CONCEPT_A_PRIMARY_100}};
  --color-primary-200: {{CONCEPT_A_PRIMARY_200}};
  --color-primary-300: {{CONCEPT_A_PRIMARY_300}};
  --color-primary-400: {{CONCEPT_A_PRIMARY_400}};
  --color-primary-500: {{CONCEPT_A_PRIMARY_500}}; /* Primary brand color */
  --color-primary-600: {{CONCEPT_A_PRIMARY_600}};
  --color-primary-700: {{CONCEPT_A_PRIMARY_700}};
  --color-primary-800: {{CONCEPT_A_PRIMARY_800}};
  --color-primary-900: {{CONCEPT_A_PRIMARY_900}};

  /* Accent Colors */
  --color-accent-50: {{CONCEPT_A_ACCENT_50}};
  --color-accent-100: {{CONCEPT_A_ACCENT_100}};
  --color-accent-200: {{CONCEPT_A_ACCENT_200}};
  --color-accent-300: {{CONCEPT_A_ACCENT_300}};
  --color-accent-400: {{CONCEPT_A_ACCENT_400}};
  --color-accent-500: {{CONCEPT_A_ACCENT_500}}; /* Accent color */
  --color-accent-600: {{CONCEPT_A_ACCENT_600}};
  --color-accent-700: {{CONCEPT_A_ACCENT_700}};
  --color-accent-800: {{CONCEPT_A_ACCENT_800}};
  --color-accent-900: {{CONCEPT_A_ACCENT_900}};

  /* Neutral Colors */
  --color-neutral-50: {{CONCEPT_A_NEUTRAL_50}};
  --color-neutral-100: {{CONCEPT_A_NEUTRAL_100}};
  --color-neutral-200: {{CONCEPT_A_NEUTRAL_200}};
  --color-neutral-300: {{CONCEPT_A_NEUTRAL_300}};
  --color-neutral-400: {{CONCEPT_A_NEUTRAL_400}};
  --color-neutral-500: {{CONCEPT_A_NEUTRAL_500}};
  --color-neutral-600: {{CONCEPT_A_NEUTRAL_600}};
  --color-neutral-700: {{CONCEPT_A_NEUTRAL_700}};
  --color-neutral-800: {{CONCEPT_A_NEUTRAL_800}};
  --color-neutral-900: {{CONCEPT_A_NEUTRAL_900}};
}
```

### Typography Scale
```css
/* Typography Variables */
:root {
  /* Font Families */
  --font-family-primary: {{CONCEPT_A_FONT_PRIMARY}};
  --font-family-mono: {{CONCEPT_A_FONT_MONO}};

  /* Font Sizes */
  --font-size-heading-1: {{CONCEPT_A_HEADING_1_SIZE}};
  --font-size-heading-2: {{CONCEPT_A_HEADING_2_SIZE}};
  --font-size-heading-3: {{CONCEPT_A_HEADING_3_SIZE}};
  --font-size-heading-4: {{CONCEPT_A_HEADING_4_SIZE}};
  --font-size-body-lg: {{CONCEPT_A_BODY_LG_SIZE}};
  --font-size-body: {{CONCEPT_A_BODY_SIZE}};
  --font-size-body-sm: {{CONCEPT_A_BODY_SM_SIZE}};
  --font-size-caption: {{CONCEPT_A_CAPTION_SIZE}};

  /* Line Heights */
  --line-height-heading: {{CONCEPT_A_HEADING_LINE_HEIGHT}};
  --line-height-body: {{CONCEPT_A_BODY_LINE_HEIGHT}};

  /* Font Weights */
  --font-weight-normal: {{CONCEPT_A_FONT_WEIGHT_NORMAL}};
  --font-weight-medium: {{CONCEPT_A_FONT_WEIGHT_MEDIUM}};
  --font-weight-semibold: {{CONCEPT_A_FONT_WEIGHT_SEMIBOLD}};
  --font-weight-bold: {{CONCEPT_A_FONT_WEIGHT_BOLD}};
}
```

### Spacing System
```css
/* Spacing Variables */
:root {
  --spacing-xs: {{CONCEPT_A_SPACING_XS}};    /* {{CONCEPT_A_SPACING_XS_PX}} */
  --spacing-sm: {{CONCEPT_A_SPACING_SM}};    /* {{CONCEPT_A_SPACING_SM_PX}} */
  --spacing-md: {{CONCEPT_A_SPACING_MD}};    /* {{CONCEPT_A_SPACING_MD_PX}} */
  --spacing-lg: {{CONCEPT_A_SPACING_LG}};    /* {{CONCEPT_A_SPACING_LG_PX}} */
  --spacing-xl: {{CONCEPT_A_SPACING_XL}};    /* {{CONCEPT_A_SPACING_XL_PX}} */
  --spacing-2xl: {{CONCEPT_A_SPACING_2XL}};  /* {{CONCEPT_A_SPACING_2XL_PX}} */
  --spacing-3xl: {{CONCEPT_A_SPACING_3XL}};  /* {{CONCEPT_A_SPACING_3XL_PX}} */
}
```

### Icon Style Guidelines
- **Style**: {{CONCEPT_A_ICON_STYLE}}
- **Library**: {{CONCEPT_A_ICON_LIBRARY}}
- **Sizes**: {{CONCEPT_A_ICON_SIZES}}
- **Color**: {{CONCEPT_A_ICON_COLOR_STRATEGY}}

## Components

### AppHeader Component
```jsx
// {{CONCEPT_A_NAME}} Header
import styles from './AppHeader.module.css';

<header className={styles.header}>
  <div className={styles.container}>
    <div className={styles.headerContent}>
      {/* Logo */}
      <div className={styles.logoSection}>
        <div className={styles.logoIcon}>
          <span className={styles.logoText}>{{LOGO_INITIAL}}</span>
        </div>
        <span className={styles.brandName}>{{APPLICATION_NAME}}</span>
      </div>

      {/* Navigation */}
      <nav className={styles.navigation}>
        <a href="#" className={styles.navLink}>
          {{NAV_ITEM_1}}
        </a>
        <a href="#" className={styles.navLink}>
          {{NAV_ITEM_2}}
        </a>
        <a href="#" className={styles.navLink}>
          {{NAV_ITEM_3}}
        </a>
      </nav>

      {/* User Actions */}
      <div className={styles.userActions}>
        <button className={styles.iconButton}>
          <SearchIcon className={styles.icon} />
        </button>
        <button className={styles.iconButton}>
          <UserIcon className={styles.icon} />
        </button>
      </div>
    </div>
  </div>
</header>
```

```css
/* AppHeader.module.css */
.header {
  background-color: var(--color-neutral-50);
  border-bottom: 1px solid var(--color-neutral-200);
  position: sticky;
  top: 0;
  z-index: 50;
}

.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 var(--spacing-md);
}

.headerContent {
  display: flex;
  align-items: center;
  justify-content: space-between;
  height: 4rem;
}

.logoSection {
  display: flex;
  align-items: center;
  gap: var(--spacing-sm);
}

.logoIcon {
  width: 2rem;
  height: 2rem;
  background-color: var(--color-primary-500);
  border-radius: var(--border-radius-md);
  display: flex;
  align-items: center;
  justify-content: center;
}

.logoText {
  color: white;
  font-weight: var(--font-weight-bold);
  font-size: var(--font-size-body-sm);
}

.brandName {
  font-size: var(--font-size-heading-4);
  font-weight: var(--font-weight-semibold);
  color: var(--color-neutral-900);
}

.navigation {
  display: none;
  align-items: center;
  gap: var(--spacing-lg);
}

@media (min-width: 768px) {
  .navigation {
    display: flex;
  }
}

.navLink {
  font-size: var(--font-size-body);
  color: var(--color-neutral-600);
  text-decoration: none;
  transition: color 0.2s ease;
}

.navLink:hover {
  color: var(--color-neutral-900);
}

.userActions {
  display: flex;
  align-items: center;
  gap: var(--spacing-md);
}

.iconButton {
  padding: var(--spacing-sm);
  color: var(--color-neutral-600);
  background: none;
  border: none;
  cursor: pointer;
  transition: color 0.2s ease;
}

.iconButton:hover {
  color: var(--color-neutral-900);
}

.icon {
  width: 1.25rem;
  height: 1.25rem;
}
```

**Visual Description**: {{CONCEPT_A_HEADER_DESCRIPTION}}. Hover states provide gentle feedback without disrupting the {{CONCEPT_A_AESTHETIC_QUALITY}} aesthetic.

### AppFooter Component
```jsx
// {{CONCEPT_A_NAME}} Footer
import styles from './AppFooter.module.css';

<footer className={styles.footer}>
  <div className={styles.container}>
    <div className={styles.footerContent}>
      {/* Brand */}
      <div className={styles.brandSection}>
        <div className={styles.logoSection}>
          <div className={styles.logoIcon}>
            <span className={styles.logoText}>{{LOGO_INITIAL}}</span>
          </div>
          <span className={styles.brandName}>{{APPLICATION_NAME}}</span>
        </div>
        <p className={styles.description}>
          {{APPLICATION_DESCRIPTION}}
        </p>
      </div>

      {/* Links */}
      <div className={styles.linkSection}>
        <h3 className={styles.sectionTitle}>{{FOOTER_SECTION_1_TITLE}}</h3>
        <ul className={styles.linkList}>
          <li><a href="#" className={styles.footerLink}>{{FOOTER_LINK_1_1}}</a></li>
          <li><a href="#" className={styles.footerLink}>{{FOOTER_LINK_1_2}}</a></li>
          <li><a href="#" className={styles.footerLink}>{{FOOTER_LINK_1_3}}</a></li>
        </ul>
      </div>

      <div className={styles.linkSection}>
        <h3 className={styles.sectionTitle}>{{FOOTER_SECTION_2_TITLE}}</h3>
        <ul className={styles.linkList}>
          <li><a href="#" className={styles.footerLink}>{{FOOTER_LINK_2_1}}</a></li>
          <li><a href="#" className={styles.footerLink}>{{FOOTER_LINK_2_2}}</a></li>
          <li><a href="#" className={styles.footerLink}>{{FOOTER_LINK_2_3}}</a></li>
        </ul>
      </div>
    </div>

    <div className={styles.copyright}>
      <p className={styles.copyrightText}>
        © {{CURRENT_YEAR}} {{APPLICATION_NAME}}. All rights reserved.
      </p>
    </div>
  </div>
</footer>
```

```css
/* AppFooter.module.css */
.footer {
  background-color: var(--color-neutral-50);
  border-top: 1px solid var(--color-neutral-200);
  margin-top: auto;
}

.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: var(--spacing-3xl) var(--spacing-md);
}

.footerContent {
  display: grid;
  grid-template-columns: 1fr;
  gap: var(--spacing-lg);
}

@media (min-width: 768px) {
  .footerContent {
    grid-template-columns: 2fr 1fr 1fr;
  }
}

.brandSection {
  grid-column: span 1;
}

@media (min-width: 768px) {
  .brandSection {
    grid-column: span 2;
  }
}

.logoSection {
  display: flex;
  align-items: center;
  gap: var(--spacing-sm);
  margin-bottom: var(--spacing-md);
}

.logoIcon {
  width: 2rem;
  height: 2rem;
  background-color: var(--color-primary-500);
  border-radius: var(--border-radius-md);
  display: flex;
  align-items: center;
  justify-content: center;
}

.logoText {
  color: white;
  font-weight: var(--font-weight-bold);
  font-size: var(--font-size-body-sm);
}

.brandName {
  font-size: var(--font-size-heading-4);
  font-weight: var(--font-weight-semibold);
  color: var(--color-neutral-900);
}

.description {
  font-size: var(--font-size-body-sm);
  color: var(--color-neutral-600);
  max-width: 24rem;
}

.sectionTitle {
  font-size: var(--font-size-body);
  font-weight: var(--font-weight-semibold);
  color: var(--color-neutral-900);
  margin-bottom: var(--spacing-md);
}

.linkList {
  list-style: none;
  padding: 0;
  margin: 0;
  display: flex;
  flex-direction: column;
  gap: var(--spacing-sm);
}

.footerLink {
  font-size: var(--font-size-body-sm);
  color: var(--color-neutral-600);
  text-decoration: none;
  transition: color 0.2s ease;
}

.footerLink:hover {
  color: var(--color-neutral-900);
}

.copyright {
  border-top: 1px solid var(--color-neutral-200);
  margin-top: var(--spacing-lg);
  padding-top: var(--spacing-lg);
}

.copyrightText {
  font-size: var(--font-size-caption);
  color: var(--color-neutral-500);
  text-align: center;
}
```

**Visual Description**: {{CONCEPT_A_FOOTER_DESCRIPTION}}. Clean typography hierarchy maintains the {{CONCEPT_A_AESTHETIC_QUALITY}} feel.

### Home Page Layout
```jsx
// Modern/Minimal Home Page
<div className="min-h-screen bg-white">
  {/* Hero Section */}
  <section className="bg-gradient-to-b from-neutral-50 to-white py-16 lg:py-24">
    <div className="container mx-auto px-4 sm:px-6 lg:px-8">
      <div className="max-w-3xl mx-auto text-center">
        <h1 className="text-heading-1 text-neutral-900 mb-6">
          Effortless Family Meal Planning
        </h1>
        <p className="text-body-lg text-neutral-600 mb-8">
          Organize your weekly meals, discover new recipes, and streamline grocery shopping
          with our intuitive family-focused platform.
        </p>
        <div className="flex flex-col sm:flex-row gap-4 justify-center">
          <button className="bg-primary-500 text-white px-8 py-3 rounded-lg text-body font-medium hover:bg-primary-600 transition-colors">
            Start Planning
          </button>
          <button className="border border-neutral-300 text-neutral-700 px-8 py-3 rounded-lg text-body font-medium hover:bg-neutral-50 transition-colors">
            Browse Recipes
          </button>
        </div>
      </div>
    </div>
  </section>

  {/* Quick Actions */}
  <section className="py-16">
    <div className="container mx-auto px-4 sm:px-6 lg:px-8">
      <h2 className="text-heading-2 text-neutral-900 text-center mb-12">
        Everything You Need
      </h2>
      <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
        <div className="text-center p-6">
          <div className="w-16 h-16 bg-accent-100 rounded-2xl flex items-center justify-center mx-auto mb-4">
            <CalendarIcon className="w-8 h-8 text-accent-600" />
          </div>
          <h3 className="text-heading-4 text-neutral-900 mb-2">Weekly Planning</h3>
          <p className="text-body text-neutral-600">
            Plan your family's meals for the entire week with our intuitive calendar interface.
          </p>
        </div>
        <div className="text-center p-6">
          <div className="w-16 h-16 bg-accent-100 rounded-2xl flex items-center justify-center mx-auto mb-4">
            <BookOpenIcon className="w-8 h-8 text-accent-600" />
          </div>
          <h3 className="text-heading-4 text-neutral-900 mb-2">Recipe Discovery</h3>
          <p className="text-body text-neutral-600">
            Explore thousands of family-friendly recipes tailored to your preferences.
          </p>
        </div>
        <div className="text-center p-6">
          <div className="w-16 h-16 bg-accent-100 rounded-2xl flex items-center justify-center mx-auto mb-4">
            <ShoppingCartIcon className="w-8 h-8 text-accent-600" />
          </div>
          <h3 className="text-heading-4 text-neutral-900 mb-2">Smart Grocery Lists</h3>
          <p className="text-body text-neutral-600">
            Automatically generate shopping lists based on your planned meals.
          </p>
        </div>
      </div>
    </div>
  </section>

  {/* This Week's Plan Preview */}
  <section className="py-16 bg-neutral-50">
    <div className="container mx-auto px-4 sm:px-6 lg:px-8">
      <div className="flex items-center justify-between mb-8">
        <h2 className="text-heading-2 text-neutral-900">This Week's Plan</h2>
        <button className="text-body text-primary-600 hover:text-primary-700 font-medium">
          View Full Plan →
        </button>
      </div>
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
        {/* Day Cards */}
        <div className="bg-white rounded-xl p-6 border border-neutral-200">
          <div className="text-caption text-neutral-500 mb-2">Monday</div>
          <h3 className="text-body font-medium text-neutral-900 mb-1">Grilled Chicken Salad</h3>
          <p className="text-body-sm text-neutral-600">30 min • 4 servings</p>
        </div>
        <div className="bg-white rounded-xl p-6 border border-neutral-200">
          <div className="text-caption text-neutral-500 mb-2">Tuesday</div>
          <h3 className="text-body font-medium text-neutral-900 mb-1">Pasta Primavera</h3>
          <p className="text-body-sm text-neutral-600">25 min • 4 servings</p>
        </div>
        <div className="bg-white rounded-xl p-6 border border-neutral-200">
          <div className="text-caption text-neutral-500 mb-2">Wednesday</div>
          <h3 className="text-body font-medium text-neutral-900 mb-1">Fish Tacos</h3>
          <p className="text-body-sm text-neutral-600">20 min • 4 servings</p>
        </div>
        <div className="bg-white rounded-xl p-6 border border-neutral-200 border-dashed">
          <div className="text-caption text-neutral-500 mb-2">Thursday</div>
          <button className="text-body text-neutral-400 hover:text-neutral-600">
            + Add Meal
          </button>
        </div>
      </div>
    </div>
  </section>
</div>
```

**Visual Description**: Clean, spacious layout with subtle gradients and generous whitespace. Card-based design with soft shadows and rounded corners. Muted color palette with strategic use of accent colors for CTAs.

### Recipe Listing Page
```jsx
// Modern/Minimal Recipe Listing
<div className="min-h-screen bg-white">
  {/* Search and Filters */}
  <section className="bg-neutral-50 py-8">
    <div className="container mx-auto px-4 sm:px-6 lg:px-8">
      <div className="max-w-4xl mx-auto">
        <h1 className="text-heading-2 text-neutral-900 mb-6">Recipe Collection</h1>

        {/* Search Bar */}
        <div className="relative mb-6">
          <SearchIcon className="absolute left-4 top-1/2 transform -translate-y-1/2 w-5 h-5 text-neutral-400" />
          <input
            type="text"
            placeholder="Search recipes..."
            className="w-full pl-12 pr-4 py-3 border border-neutral-300 rounded-lg text-body focus:ring-2 focus:ring-primary-500 focus:border-transparent"
          />
        </div>

        {/* Filter Tags */}
        <div className="flex flex-wrap gap-2">
          <button className="px-4 py-2 bg-primary-500 text-white rounded-full text-body-sm font-medium">
            All Recipes
          </button>
          <button className="px-4 py-2 bg-white border border-neutral-300 text-neutral-700 rounded-full text-body-sm font-medium hover:bg-neutral-50">
            Quick & Easy
          </button>
          <button className="px-4 py-2 bg-white border border-neutral-300 text-neutral-700 rounded-full text-body-sm font-medium hover:bg-neutral-50">
            Vegetarian
          </button>
          <button className="px-4 py-2 bg-white border border-neutral-300 text-neutral-700 rounded-full text-body-sm font-medium hover:bg-neutral-50">
            Kid-Friendly
          </button>
        </div>
      </div>
    </div>
  </section>

  {/* Recipe Grid */}
  <section className="py-12">
    <div className="container mx-auto px-4 sm:px-6 lg:px-8">
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
        {/* Recipe Card */}
        <div className="bg-white rounded-xl border border-neutral-200 overflow-hidden hover:shadow-lg transition-shadow">
          <div className="aspect-w-16 aspect-h-12 bg-neutral-100">
            <img src="/recipe-image.jpg" alt="Recipe" className="w-full h-48 object-cover" />
          </div>
          <div className="p-6">
            <h3 className="text-heading-4 text-neutral-900 mb-2">Mediterranean Quinoa Bowl</h3>
            <p className="text-body-sm text-neutral-600 mb-4">
              Fresh vegetables, quinoa, and feta cheese with lemon vinaigrette
            </p>
            <div className="flex items-center justify-between text-body-sm text-neutral-500">
              <span className="flex items-center">
                <ClockIcon className="w-4 h-4 mr-1" />
                25 min
              </span>
              <span className="flex items-center">
                <UsersIcon className="w-4 h-4 mr-1" />
                4 servings
              </span>
            </div>
            <div className="flex items-center justify-between mt-4">
              <div className="flex items-center">
                <StarIcon className="w-4 h-4 text-accent-500 fill-current" />
                <span className="text-body-sm text-neutral-600 ml-1">4.8 (124)</span>
              </div>
              <button className="text-primary-600 hover:text-primary-700 text-body-sm font-medium">
                View Recipe
              </button>
            </div>
          </div>
        </div>

        {/* Additional recipe cards would repeat this pattern */}
      </div>

      {/* Load More */}
      <div className="text-center mt-12">
        <button className="border border-neutral-300 text-neutral-700 px-8 py-3 rounded-lg text-body font-medium hover:bg-neutral-50 transition-colors">
          Load More Recipes
        </button>
      </div>
    </div>
  </section>
</div>
```

**Visual Description**: Clean grid layout with minimal recipe cards featuring high-quality images. Subtle borders and hover effects. Search and filtering interface with pill-shaped tags.

### Recipe Detail Page
```jsx
// Modern/Minimal Recipe Detail
<div className="min-h-screen bg-white">
  {/* Hero Section */}
  <section className="relative">
    <div className="aspect-w-16 aspect-h-9 bg-neutral-100">
      <img src="/recipe-hero.jpg" alt="Recipe" className="w-full h-96 object-cover" />
    </div>
    <div className="absolute inset-0 bg-gradient-to-t from-black/50 to-transparent" />
    <div className="absolute bottom-0 left-0 right-0 p-8">
      <div className="container mx-auto px-4 sm:px-6 lg:px-8">
        <h1 className="text-heading-1 text-white mb-4">Mediterranean Quinoa Bowl</h1>
        <div className="flex items-center space-x-6 text-white/90">
          <span className="flex items-center">
            <ClockIcon className="w-5 h-5 mr-2" />
            25 minutes
          </span>
          <span className="flex items-center">
            <UsersIcon className="w-5 h-5 mr-2" />
            4 servings
          </span>
          <span className="flex items-center">
            <StarIcon className="w-5 h-5 mr-2 fill-current" />
            4.8 (124 reviews)
          </span>
        </div>
      </div>
    </div>
  </section>

  {/* Content */}
  <section className="py-12">
    <div className="container mx-auto px-4 sm:px-6 lg:px-8">
      <div className="max-w-4xl mx-auto">
        <div className="grid grid-cols-1 lg:grid-cols-3 gap-12">
          {/* Ingredients */}
          <div className="lg:col-span-1">
            <div className="bg-neutral-50 rounded-xl p-6 sticky top-24">
              <h2 className="text-heading-3 text-neutral-900 mb-6">Ingredients</h2>
              <ul className="space-y-3">
                <li className="flex items-center">
                  <input type="checkbox" className="w-4 h-4 text-primary-600 rounded mr-3" />
                  <span className="text-body text-neutral-700">1 cup quinoa, rinsed</span>
                </li>
                <li className="flex items-center">
                  <input type="checkbox" className="w-4 h-4 text-primary-600 rounded mr-3" />
                  <span className="text-body text-neutral-700">2 cups vegetable broth</span>
                </li>
                <li className="flex items-center">
                  <input type="checkbox" className="w-4 h-4 text-primary-600 rounded mr-3" />
                  <span className="text-body text-neutral-700">1 cucumber, diced</span>
                </li>
                <li className="flex items-center">
                  <input type="checkbox" className="w-4 h-4 text-primary-600 rounded mr-3" />
                  <span className="text-body text-neutral-700">2 tomatoes, chopped</span>
                </li>
                <li className="flex items-center">
                  <input type="checkbox" className="w-4 h-4 text-primary-600 rounded mr-3" />
                  <span className="text-body text-neutral-700">1/2 cup feta cheese, crumbled</span>
                </li>
              </ul>

              <button className="w-full mt-6 bg-accent-500 text-white py-3 rounded-lg text-body font-medium hover:bg-accent-600 transition-colors">
                Add to Grocery List
              </button>
            </div>
          </div>

          {/* Instructions */}
          <div className="lg:col-span-2">
            <h2 className="text-heading-3 text-neutral-900 mb-6">Instructions</h2>
            <div className="space-y-6">
              <div className="flex">
                <div className="flex-shrink-0 w-8 h-8 bg-primary-500 text-white rounded-full flex items-center justify-center text-body-sm font-medium mr-4">
                  1
                </div>
                <div>
                  <p className="text-body text-neutral-700">
                    Rinse quinoa under cold water until water runs clear. In a medium saucepan,
                    bring vegetable broth to a boil.
                  </p>
                </div>
              </div>

              <div className="flex">
                <div className="flex-shrink-0 w-8 h-8 bg-primary-500 text-white rounded-full flex items-center justify-center text-body-sm font-medium mr-4">
                  2
                </div>
                <div>
                  <p className="text-body text-neutral-700">
                    Add quinoa to boiling broth, reduce heat to low, cover and simmer for 15 minutes
                    until liquid is absorbed.
                  </p>
                </div>
              </div>

              <div className="flex">
                <div className="flex-shrink-0 w-8 h-8 bg-primary-500 text-white rounded-full flex items-center justify-center text-body-sm font-medium mr-4">
                  3
                </div>
                <div>
                  <p className="text-body text-neutral-700">
                    Remove from heat and let stand 5 minutes. Fluff with a fork and let cool completely.
                  </p>
                </div>
              </div>

              <div className="flex">
                <div className="flex-shrink-0 w-8 h-8 bg-primary-500 text-white rounded-full flex items-center justify-center text-body-sm font-medium mr-4">
                  4
                </div>
                <div>
                  <p className="text-body text-neutral-700">
                    In a large bowl, combine cooled quinoa, cucumber, tomatoes, and feta cheese.
                    Drizzle with lemon vinaigrette and toss gently.
                  </p>
                </div>
              </div>
            </div>

            {/* Action Buttons */}
            <div className="flex flex-col sm:flex-row gap-4 mt-8">
              <button className="bg-primary-500 text-white px-6 py-3 rounded-lg text-body font-medium hover:bg-primary-600 transition-colors">
                Add to Meal Plan
              </button>
              <button className="border border-neutral-300 text-neutral-700 px-6 py-3 rounded-lg text-body font-medium hover:bg-neutral-50 transition-colors">
                Save Recipe
              </button>
              <button className="border border-neutral-300 text-neutral-700 px-6 py-3 rounded-lg text-body font-medium hover:bg-neutral-50 transition-colors">
                Share Recipe
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
</div>
```

**Visual Description**: Hero image with gradient overlay and white text. Two-column layout with sticky ingredients sidebar. Numbered instruction steps with circular indicators. Clean action buttons with consistent styling.

## Responsive Breakpoints

### Mobile (320px - 639px)
- Single column layouts
- Stacked navigation in header
- Full-width cards and buttons
- Reduced padding and margins
- Touch-optimized spacing (minimum 44px touch targets)

### Tablet (640px - 1023px)
- Two-column grids for recipe cards
- Horizontal navigation in header
- Increased padding for better readability
- Side-by-side action buttons

### Desktop (1024px+)
- Multi-column layouts (3-4 columns for recipe grids)
- Full navigation with all links visible
- Sticky sidebar elements
- Hover states and transitions
- Optimal reading widths with centered content

## Implementation Guidelines

### Next.js Integration
```javascript
// Component structure
/components
  /layout
    - Header.tsx
    - Footer.tsx
    - Layout.tsx
  /pages
    - HomePage.tsx
    - RecipeListPage.tsx
    - RecipeDetailPage.tsx
  /ui
    - Button.tsx
    - Card.tsx
    - Input.tsx
```

### CSS Modules Configuration
```css
/* design-tokens.css - Complete {{CONCEPT_A_NAME}} Design System */
:root {
  /* Color palette as defined above */
  /* Typography as defined above */
  /* Spacing as defined above */

  /* Border Radius */
  --border-radius-sm: {{CONCEPT_A_BORDER_RADIUS_SM}};
  --border-radius-md: {{CONCEPT_A_BORDER_RADIUS_MD}};
  --border-radius-lg: {{CONCEPT_A_BORDER_RADIUS_LG}};

  /* Shadows */
  --shadow-sm: {{CONCEPT_A_SHADOW_SM}};
  --shadow-md: {{CONCEPT_A_SHADOW_MD}};
  --shadow-lg: {{CONCEPT_A_SHADOW_LG}};

  /* Transitions */
  --transition-fast: {{CONCEPT_A_TRANSITION_FAST}};
  --transition-normal: {{CONCEPT_A_TRANSITION_NORMAL}};
  --transition-slow: {{CONCEPT_A_TRANSITION_SLOW}};
}

/* Animation Keyframes */
@keyframes fadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}

@keyframes slideUp {
  from {
    transform: translateY(10px);
    opacity: 0;
  }
  to {
    transform: translateY(0);
    opacity: 1;
  }
}

/* Utility Classes */
.fadeIn {
  animation: fadeIn var(--transition-normal) ease-in-out;
}

.slideUp {
  animation: slideUp var(--transition-fast) ease-out;
}
```

### Accessibility Implementation
- **Focus Management**: Clear focus rings using CSS custom properties and `:focus` pseudo-class
- **Color Contrast**: All text meets WCAG AA standards
- **Keyboard Navigation**: Tab order follows logical flow
- **Screen Readers**: Proper ARIA labels and semantic HTML
- **Touch Targets**: Minimum 44px for all interactive elements

```css
/* Focus styles in component modules */
.button:focus {
  outline: 2px solid var(--color-primary-500);
  outline-offset: 2px;
}

.input:focus {
  border-color: var(--color-primary-500);
  box-shadow: 0 0 0 3px rgba(var(--color-primary-500-rgb), 0.1);
}
```

### Performance Considerations
- **Image Optimization**: Next.js Image component with proper sizing
- **Code Splitting**: Component-level code splitting
- **CSS Optimization**: Only used styles are included through CSS Modules
- **Font Loading**: Optimized web font loading with font-display: swap

### Browser Support
- **Modern Browsers**: Chrome 90+, Firefox 88+, Safari 14+, Edge 90+
- **Graceful Degradation**: Fallbacks for CSS Grid and Flexbox
- **Progressive Enhancement**: Core functionality works without JavaScript

This {{CONCEPT_A_NAME}} concept emphasizes {{CONCEPT_A_EMPHASIS}} through {{CONCEPT_A_DESIGN_PATTERNS}} that enhance rather than distract from the {{APPLICATION_PURPOSE}} experience.
