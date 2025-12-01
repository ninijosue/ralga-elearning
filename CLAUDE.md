# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Moodle-based e-learning platform with custom analytics and user registration plugins, running in a Dockerized environment. The project extends Moodle with two major custom plugins that use modern Lit web components for the frontend.

## Development Commands

### Docker Environment

```bash
# Start all services (MariaDB + Moodle)
docker compose up -d

# Stop all services
docker compose down

# View logs
docker compose logs -f moodle
docker compose logs -f db

# Rebuild Moodle container (after Dockerfile changes)
docker compose build moodle
docker compose up -d moodle

# Access Moodle container shell
docker compose exec moodle bash

# Access MariaDB
docker compose exec db mysql -u root -p
# Password: gov@123
```

### Frontend Development

Both custom plugins have TypeScript/Lit frontends that require building:

```bash
# Real Dashboard Block
cd elearning/blocks/realdashboard/frontend/
pnpm install                    # Install dependencies
pnpm run dev                    # Watch mode with auto-rebuild
pnpm run build                  # Production build
pnpm run clean                  # Clean dist and rebuild

# Additional User Details Plugin
cd elearning/local/additionaluserdetails/frontend/
pnpm install
pnpm run dev                    # Watch mode
pnpm run build                  # Production build
pnpm run tailwind               # Tailwind CSS watch mode
```

**Note:** After building frontend changes, refresh browser to see updates at http://localhost:8086

### Moodle Access

- URL: http://localhost:8086
- Database: MariaDB on localhost:3306
- Admin dashboard: http://localhost:8086/admin

## Architecture

### Service Architecture

Two Docker services defined in `compose.yaml`:

1. **db (MariaDB)** - Database service
   - Port 3306 exposed
   - Data persisted in `./db/` directory
   - Initialization SQL in `./init-scripts/init.sql` (242MB, runs on first start)

2. **moodle (PHP 8.1-Apache)** - Web application
   - Port 8086 exposed
   - Mounts `./elearning/` as `/var/www/html` (Moodle core + plugins)
   - Mounts `./moodledata/` as `/var/www/moodledata` (file storage, cache)
   - PHP extensions: mysqli, zip, soap, intl, gd

### Custom Plugins

#### 1. Real Dashboard Block (`elearning/blocks/realdashboard/`)

**Purpose:** Comprehensive analytics dashboard showing enrollment trends, learning outcomes, and student performance metrics.

**Architecture:**
- **Backend (PHP):**
  - `block_realdashboard.php` - Main block class
  - `get_data.php` - Primary analytics API (1442 lines) - aggregates data from enrollments, completions, grades, and custom user details
  - `get_courses_list.php`, `get_student_coruses.php`, `get_course_categories.php` - Supporting APIs

- **Frontend (Lit Web Components):**
  - Tech stack: Lit 3.3.1 + TypeScript 5.8.3 + Tailwind CSS 4.1.11
  - Build: Rollup 4.45.1 with PostCSS pipeline
  - Components: `<dashboard-main>`, `<learner-dashboard>`, `<enrollment-tab>`, `<learning-tab>`, `<students-tab>`, `<filter-content>`
  - Output: `frontend/dist/index_002.js` and `styles.css`

**Role-Based Rendering:**
- Admins/managers see `<dashboard-main>` with full analytics
- Learners see `<learner-dashboard>` with personal progress

**Data Flow:**
1. Block loads compiled Lit components from `frontend/dist/`
2. Components make POST requests to `get_data.php`
3. Backend queries 15+ filters across demographics, location hierarchy, courses, date ranges
4. Aggregates data from: `mdl_user_enrolments`, `mdl_course_completions`, `mdl_customcert_issues`, `mdl_grade_grades`, `mdl_additional_user_details`
5. Returns JSON with enrollment/learning/student analytics
6. Lit components render charts using Chart.js

#### 2. Additional User Details Plugin (`elearning/local/additionaluserdetails/`)

**Purpose:** Captures extended demographic information beyond Moodle's default user profile. Integrates with external citizen verification API.

**Architecture:**
- **Database:** Custom table `mdl_additional_user_details` with 12 indexed fields
  - Demographics: nationalid, dateofbirth, gender, position
  - Location hierarchy: district → sector → cell → village
  - Service point data: healthfacility, servicepointcategory

- **Backend (PHP):**
  - `lib.php` - Hook that redirects users to registration if not completed
  - `register.php` - Registration form UI (loads Lit component)
  - `getcitizeninfo.php` - Fetches citizen data from external API via JWT auth
  - `saveuserinfo.php` - Saves user details to database

- **Frontend (Lit Web Components):**
  - `<main-page>` - Multi-step registration form
  - Pre-populated Rwanda location data (districts/sectors/cells/villages)
  - Health facilities integration
  - Form validation with error states

**Integration Hook:**
```php
// Executes before every page load
function local_additionaluserdetails_before_http_headers() {
    // Redirect logged-in non-admin users who haven't completed registration
    if (user_not_in_additional_user_details_table) {
        redirect('/local/additionaluserdetails/register.php');
    }
}
```

**External API Integration:**
- Configuration in `elearning/local/additionaluserdetails/env.php` (not in git)
- JWT authentication flow: login → receive token → fetch citizen data
- Supports dev/prod environment switching

### Frontend Build Pipeline

Both plugins use identical Rollup configuration:

1. TypeScript compilation (`@rollup/plugin-typescript`)
2. Node module resolution for Lit imports
3. PostCSS processing:
   - `postcss-import` - Resolve CSS imports
   - `@tailwindcss/postcss` - Process Tailwind directives
   - `autoprefixer` - Add browser prefixes
   - `postcss-lit` - Process Lit component styles
4. Terser minification (production builds)
5. Output: ES modules loaded via `import()` in Moodle pages

**Key Pattern:** Shadow DOM disabled (`createRenderRoot() { return this; }`) to allow global Tailwind classes to style components.

### Analytics Query Architecture

The `get_data.php` endpoint performs complex multi-table aggregation:

1. **Filter Processing:** Parse 15+ optional filters from POST data
2. **User Filtering:** Query `mdl_additional_user_details` with location/demographic filters
3. **Enrollment Data:** Join with `mdl_user_enrolments` filtered by date range
4. **Completion Data:** UNION query combining:
   - Standard Moodle completions (`mdl_course_completions`)
   - Certificate-based completions (`mdl_customcert_issues`)
5. **Grade Data:** Aggregate from `mdl_grade_grades` to calculate pass/fail rates
6. **Analytics Generation:**
   - Age distribution (4 groups: <25, 25-34, 35-44, 45+)
   - Location hierarchy metrics (district/sector/cell/village)
   - Monthly trends using PHP DateInterval/DatePeriod
   - Position-based analytics
   - Course-specific performance
   - Gender breakdown

**Performance:** Indexed fields on custom table enable fast filtering across demographics and location hierarchy.

## Database Schema

### Custom Table: `mdl_additional_user_details`

```sql
-- Key fields (all indexed):
userid (FK to mdl_user.id with CASCADE delete)
nationalid (UNIQUE)
district, sector, cell, village  -- Rwanda location hierarchy
gender, position, dateofbirth
servicepointcategory, healthfacility
phonenumber, email
```

**Initialization:** The 242MB `init-scripts/init.sql` creates full Moodle schema including this custom table. Runs automatically on first MariaDB container start.

## Key File Locations

- **Moodle config:** `elearning/config.php` or `text.tx` (appears to be config backup)
- **Docker config:** `compose.yaml`, `Dockerfile`
- **Custom plugins:**
  - `elearning/blocks/realdashboard/` - Analytics dashboard
  - `elearning/local/additionaluserdetails/` - User registration
- **Frontend source:**
  - `elearning/blocks/realdashboard/frontend/src/`
  - `elearning/local/additionaluserdetails/frontend/src/`
- **Compiled frontend:**
  - `elearning/blocks/realdashboard/frontend/dist/index_002.js`
  - `elearning/local/additionaluserdetails/frontend/dist/index_002.js`

## Common Development Patterns

### Adding Analytics Filters

To add a new filter dimension to the dashboard:

1. Update `get_data.php` to accept new POST parameter
2. Add filtering logic to user query section
3. Update `<filter-content>` component in `frontend/src/components/` to include new filter UI
4. Rebuild frontend: `pnpm run build`

### Modifying Registration Form

The registration form uses Rwanda-specific location data and health facilities:

1. Location data: Hardcoded in `frontend/src/data/locations.ts` (districts/sectors/cells/villages)
2. Health facilities: Hardcoded in `frontend/src/data/healthFacilities.ts`
3. Form component: `frontend/src/components/main-page.ts`
4. Save endpoint: `saveuserinfo.php`

### Debugging Frontend Components

Lit components use reactive properties with decorators:
- `@property()` - Public reactive properties (re-render on change)
- `@state()` - Private reactive state
- `@query()` - Query elements in render output

Enable debug logging in browser console to see Lit lifecycle events.

### Working with Moodle APIs

Both plugins integrate with Moodle's plugin system:

- **Blocks:** Extend `block_base` class in `block_*.php`
- **Local plugins:** Use hooks defined in `db/hooks.php`
- **Database:** Schema in `db/install.xml`, upgrade logic in `db/upgrade.php`
- **Capabilities:** Define in `db/access.php`
- **Language strings:** Store in `lang/en/block_*.php` or `lang/en/local_*.php`

## Environment Configuration

### External API Setup

Create `elearning/local/additionaluserdetails/env.php`:

```php
<?php
return [
    'production' => false,  // Set to true for production
    'dev_username' => 'your_dev_username',
    'dev_password' => 'your_dev_password',
    'dev_keyphrase' => 'your_dev_keyphrase',
    'dev_loginurl' => 'https://dev-api.example.com/login',
    'dev_citizenurl' => 'https://dev-api.example.com/citizen',
    'prod_username' => 'your_prod_username',
    'prod_password' => 'your_prod_password',
    'prod_keyphrase' => 'your_prod_keyphrase',
    'prod_loginurl' => 'https://api.example.com/login',
    'prod_citizenurl' => 'https://api.example.com/citizen',
];
```

This file is not tracked in git (should be added to .gitignore).

## Technology Stack

- **Backend:** PHP 8.1, Moodle LMS, MariaDB
- **Frontend:** TypeScript 5.8.3, Lit 3.3.1, Tailwind CSS 4.1.11
- **Build Tools:** Rollup 4.45.1, PostCSS 8.5.6, pnpm 10.6.3
- **Containerization:** Docker Compose
- **Visualization:** Chart.js (loaded from CDN)
