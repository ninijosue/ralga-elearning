# RALGA E-Learning Platform

A comprehensive Moodle-based e-learning platform designed for local governance training in Rwanda, featuring custom analytics dashboards and enhanced user registration capabilities.

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Configuration](#configuration)
- [Running the Platform](#running-the-platform)
- [Frontend Development](#frontend-development)
- [Custom Plugins](#custom-plugins)
- [Database](#database)
- [Troubleshooting](#troubleshooting)
- [Development Workflow](#development-workflow)
- [Contributing](#contributing)
- [License](#license)

## Overview

The RALGA E-Learning Platform is built on Moodle LMS and provides specialized training for local government officials in Rwanda. It offers practical online training in key areas like CRVS (Civil Registration and Vital Statistics), MEIS (Monitoring and Evaluation Information System), and SRIS (Social Registry Information System) to build skills and strengthen local governance.

### Key Highlights

- **Custom Space Theme**: Modern, responsive design with diamond-shaped cards and clean UI
- **Real Dashboard Block**: Comprehensive analytics showing enrollment trends, learning outcomes, and student performance
- **Additional User Details Plugin**: Extended demographic information capture with Rwanda-specific location hierarchy
- **Dockerized Environment**: Easy deployment with Docker Compose
- **Modern Frontend**: Built with Lit web components and TypeScript

## Features

### For Administrators

- **Advanced Analytics Dashboard**: Track enrollments, completions, and performance metrics
- **Multi-dimensional Filtering**: Filter by demographics, location, courses, and date ranges
- **Custom User Details**: Capture extended information including National ID, location hierarchy, and service points
- **Role-based Access**: Different dashboards for admins and learners

### For Learners

- **Personalized Dashboard**: View your own progress and achievements
- **Learning at Your Convenience**: Access educational materials anytime, anywhere
- **Certificate Tracking**: Monitor course completions and certificates earned
- **Mobile-Responsive**: Access from any device

### Platform Offers

1. **Specialized Governance Training**: Training local government officials on topics such as CRVS, MEIS, SRIS and so on
2. **Capacity Growth Programs**: Offering courses to develop skills in specific areas
3. **Learning at Your Convenience**: Providing access to educational materials and resources, planning, promoting continuous learning and development
4. **Strengthening Digital Capacity**: Providing access to educational materials anywhere, promoting continuous learning and development

## Prerequisites

Before you begin, ensure you have the following installed:

- **Docker** (version 20.10 or higher)
- **Docker Compose** (version 2.0 or higher)
- **pnpm** (version 8.0 or higher) - for frontend development
- **Git** (version 2.30 or higher)
- **Node.js** (version 18.0 or higher) - for frontend development

### System Requirements

- **RAM**: Minimum 4GB, recommended 8GB
- **Storage**: Minimum 10GB free space
- **OS**: macOS, Linux, or Windows with WSL2

## Installation

### 1. Clone the Repository

```bash
git clone https://github.com/ninijosue/ralga-elearning.git
cd ralga-elearning
```

### 2. Environment Setup

The database initialization script is included in the `init-scripts/` directory (242MB). This will automatically run on first container start.

### 3. Start Docker Services

```bash
# Start all services (MariaDB + Moodle)
docker compose up -d

# View logs to monitor startup
docker compose logs -f moodle
```

**Note**: First startup may take 5-10 minutes as the database initializes.

### 4. Access the Platform

Once the containers are running, access the platform at:

- **URL**: http://localhost:8086
- **Admin Dashboard**: http://localhost:8086/admin

## Configuration

### Database Configuration

The platform uses MariaDB with the following default settings:

- **Host**: localhost
- **Port**: 3306
- **Database**: moodle
- **Username**: root
- **Password**: gov@123

### Moodle Configuration

The main configuration file is located at:
- `elearning/config.php` (created during installation)

**Important**: This file is excluded from Git for security reasons.

### External API Configuration (Optional)

For the Additional User Details plugin to fetch citizen information, create the configuration file:

```bash
nano elearning/local/additionaluserdetails/env.php
```

Add the following content:

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

## Running the Platform

### Starting the Platform

```bash
# Start all services
docker compose up -d

# Check service status
docker compose ps

# View logs
docker compose logs -f
```

### Stopping the Platform

```bash
# Stop all services
docker compose down

# Stop and remove volumes (WARNING: This will delete all data)
docker compose down -v
```

### Accessing Container Shell

```bash
# Access Moodle container
docker compose exec moodle bash

# Access MariaDB
docker compose exec db mysql -u root -p
# Password: gov@123
```

### Rebuilding Containers

After making changes to the Dockerfile:

```bash
docker compose build moodle
docker compose up -d moodle
```

## Frontend Development

Both custom plugins have modern TypeScript/Lit frontends that require building.

### Real Dashboard Block

```bash
cd elearning/blocks/realdashboard/frontend/

# Install dependencies
pnpm install

# Development mode (watch and auto-rebuild)
pnpm run dev

# Production build
pnpm run build

# Clean and rebuild
pnpm run clean
```

### Additional User Details Plugin

```bash
cd elearning/local/additionaluserdetails/frontend/

# Install dependencies
pnpm install

# Development mode (watch and auto-rebuild)
pnpm run dev

# Production build
pnpm run build

# Tailwind CSS watch mode
pnpm run tailwind
```

### Viewing Changes

After building frontend changes:
1. Refresh your browser at http://localhost:8086
2. If changes don't appear, purge Moodle caches:

```bash
# From host machine
docker compose exec moodle php admin/cli/purge_caches.php

# Or access via browser
# http://localhost:8086/admin/purgecaches.php
```

## Custom Plugins

### 1. Real Dashboard Block

**Location**: `elearning/blocks/realdashboard/`

**Purpose**: Provides comprehensive analytics dashboard showing:
- Enrollment trends and statistics
- Learning outcomes and completion rates
- Student performance metrics
- Age distribution and demographics
- Location-based analytics (District → Sector → Cell → Village)
- Course-specific performance data

**Technology Stack**:
- Backend: PHP 8.1
- Frontend: Lit 3.3.1 + TypeScript 5.8.3
- Styling: Tailwind CSS 4.1.11
- Visualization: Chart.js
- Build: Rollup 4.45.1

**Key Files**:
- `block_realdashboard.php` - Main block class
- `get_data.php` - Analytics API (1442 lines)
- `frontend/src/` - Lit web components source
- `frontend/dist/` - Compiled JavaScript and CSS

### 2. Additional User Details Plugin

**Location**: `elearning/local/additionaluserdetails/`

**Purpose**: Captures extended demographic information:
- National ID and date of birth
- Gender and position
- Rwanda location hierarchy (District, Sector, Cell, Village)
- Health facility and service point information
- Phone number and email

**Technology Stack**:
- Backend: PHP 8.1
- Frontend: Lit 3.3.1 + TypeScript 5.8.3
- Styling: Tailwind CSS 4.1.11
- Build: Rollup 4.45.1

**Key Files**:
- `lib.php` - Hook that redirects users to registration
- `register.php` - Registration form UI
- `getcitizeninfo.php` - External API integration
- `saveuserinfo.php` - Save user details endpoint
- `frontend/src/` - Lit web components source

**Database Table**: `mdl_additional_user_details`

### 3. Custom Space Theme

**Location**: `elearning/theme/space/`

**Key Customizations**:
- Modern hero section with "Learn, Grow and Serve" messaging
- Quality Training section
- Mission and Partnership sections
- Platform Offers section with diamond-shaped cards
- Blue color theme (#1C9FF9)
- Responsive navigation

**Main Template**: `elearning/theme/space/templates/tmpl-frontpage.mustache`

## Database

### Schema

The platform uses MariaDB with a custom table for extended user details:

```sql
-- Custom table structure
mdl_additional_user_details (
    id BIGINT PRIMARY KEY,
    userid BIGINT (FK to mdl_user.id),
    nationalid VARCHAR(16) UNIQUE,
    dateofbirth DATE,
    gender VARCHAR(10),
    position VARCHAR(255),
    district VARCHAR(255),
    sector VARCHAR(255),
    cell VARCHAR(255),
    village VARCHAR(255),
    servicepointcategory VARCHAR(255),
    healthfacility VARCHAR(255),
    phonenumber VARCHAR(20),
    email VARCHAR(255)
)
```

### Backup and Restore

```bash
# Backup database
docker compose exec db mysqldump -u root -p moodle > backup.sql

# Restore database
docker compose exec -T db mysql -u root -p moodle < backup.sql
```

## Troubleshooting

### Port Conflicts

If port 3306 or 8086 is already in use:

```bash
# Find process using port
lsof -i :3306
lsof -i :8086

# Stop conflicting container
docker stop <container_name>

# Or modify ports in compose.yaml
```

### Cache Issues

If changes don't appear:

```bash
# Purge all Moodle caches
docker compose exec moodle php admin/cli/purge_caches.php

# Or via browser
# http://localhost:8086/admin/purgecaches.php
```

### Frontend Build Errors

```bash
# Clean node_modules and reinstall
cd elearning/blocks/realdashboard/frontend/
rm -rf node_modules pnpm-lock.yaml
pnpm install
pnpm run build
```

### Database Connection Issues

```bash
# Check database is running
docker compose ps db

# Check database logs
docker compose logs db

# Restart database
docker compose restart db
```

### Permission Issues

```bash
# Fix file permissions (Linux/macOS)
sudo chown -R $(whoami):$(whoami) elearning/
sudo chmod -R 755 elearning/
```

## Development Workflow

### Making Theme Changes

1. Edit template files in `elearning/theme/space/templates/`
2. Clear Moodle caches:
   ```bash
   docker compose exec moodle php admin/cli/purge_caches.php
   ```
3. Refresh browser to see changes

### Adding Analytics Filters

1. Update `elearning/blocks/realdashboard/get_data.php` to accept new POST parameter
2. Add filtering logic to user query section
3. Update `<filter-content>` component in `frontend/src/components/`
4. Rebuild frontend:
   ```bash
   cd elearning/blocks/realdashboard/frontend/
   pnpm run build
   ```
5. Clear caches and refresh browser

### Modifying Registration Form

1. Edit form component: `elearning/local/additionaluserdetails/frontend/src/components/main-page.ts`
2. Update location data: `frontend/src/data/locations.ts`
3. Update health facilities: `frontend/src/data/healthFacilities.ts`
4. Rebuild frontend:
   ```bash
   cd elearning/local/additionaluserdetails/frontend/
   pnpm run build
   ```
5. Clear caches and refresh browser

### Running Tests

```bash
# PHP Unit tests
docker compose exec moodle php admin/tool/phpunit/cli/init.php
docker compose exec moodle vendor/bin/phpunit

# Behat tests (acceptance testing)
docker compose exec moodle php admin/tool/behat/cli/init.php
docker compose exec moodle vendor/bin/behat
```

### Code Quality

```bash
# PHP CodeSniffer
docker compose exec moodle vendor/bin/phpcs --standard=moodle path/to/file.php

# Fix coding style issues
docker compose exec moodle vendor/bin/phpcbf --standard=moodle path/to/file.php

# ESLint (frontend)
cd elearning/blocks/realdashboard/frontend/
pnpm run lint
```

## Technology Stack

### Backend
- **PHP**: 8.1
- **Moodle**: LMS Framework
- **MariaDB**: 10.6
- **Apache**: 2.4

### Frontend
- **TypeScript**: 5.8.3
- **Lit**: 3.3.1 (Web Components)
- **Tailwind CSS**: 4.1.11
- **Chart.js**: 4.x (CDN)

### Build Tools
- **Rollup**: 4.45.1
- **PostCSS**: 8.5.6
- **pnpm**: 10.6.3

### DevOps
- **Docker**: Containerization
- **Docker Compose**: Multi-container orchestration

## Project Structure

```
ralgaelearning/
├── .gitignore                      # Git ignore rules
├── CLAUDE.md                       # AI assistant instructions
├── README.md                       # This file
├── compose.yaml                    # Docker Compose configuration
├── Dockerfile                      # Moodle container definition
├── db/                            # MariaDB data (excluded from Git)
├── init-scripts/                  # Database initialization (excluded from Git)
│   └── init.sql                   # Initial database schema (242MB)
├── moodledata/                    # Moodle file storage (excluded from Git)
└── elearning/                     # Moodle installation
    ├── config.php                 # Moodle configuration (excluded from Git)
    ├── blocks/
    │   └── realdashboard/         # Custom analytics dashboard
    │       ├── block_realdashboard.php
    │       ├── get_data.php       # Analytics API
    │       └── frontend/          # Lit web components
    │           ├── src/
    │           ├── dist/
    │           ├── package.json
    │           └── rollup.config.js
    ├── local/
    │   └── additionaluserdetails/ # Extended user registration
    │       ├── lib.php
    │       ├── register.php
    │       ├── getcitizeninfo.php
    │       ├── saveuserinfo.php
    │       ├── env.php            # API config (excluded from Git)
    │       └── frontend/          # Lit web components
    │           ├── src/
    │           ├── dist/
    │           ├── package.json
    │           └── rollup.config.js
    └── theme/
        └── space/                 # Custom theme
            ├── templates/
            │   ├── tmpl-frontpage.mustache
            │   └── navbar.mustache
            └── pix/               # Images and SVGs
```

## Contributing

We welcome contributions! Please follow these guidelines:

### Getting Started

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/your-feature-name`
3. Make your changes
4. Test thoroughly
5. Commit with descriptive messages
6. Push to your fork
7. Create a Pull Request

### Coding Standards

- **PHP**: Follow [Moodle Coding Style](https://moodledev.io/general/development/policies/codingstyle)
- **TypeScript**: Use ESLint configuration provided
- **CSS**: Follow Tailwind CSS best practices
- **Commits**: Use conventional commit messages

### Testing Requirements

- All PHP code must pass PHPUnit tests
- Frontend components should have proper TypeScript types
- Test on multiple browsers (Chrome, Firefox, Safari)
- Verify mobile responsiveness

## License

This project is licensed under the GNU General Public License v3.0 - see Moodle's license documentation for details.

## Support

For issues and questions:

- **GitHub Issues**: https://github.com/ninijosue/ralga-elearning/issues
- **Moodle Documentation**: https://docs.moodle.org/
- **Docker Documentation**: https://docs.docker.com/

## Acknowledgments

- **RALGA**: Rwanda Association of Local Government Authorities
- **Moodle Community**: For the excellent LMS platform
- **Lit Team**: For the modern web components framework
- **Contributors**: All developers who have contributed to this project

---

**Built with ❤️ for local governance training in Rwanda**
