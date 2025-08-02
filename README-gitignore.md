# Django + Drupal Hybrid Project

Properly configured `.gitignore` for Django + Drupal project.

## What's excluded from repository:

### Drupal (auto-generated via Composer):
- `drupal/vendor/` - Composer dependencies
- `drupal/web/core/` - Drupal core  
- `drupal/web/libraries/` - external libraries
- `drupal/web/modules/contrib/` - contrib modules
- `drupal/web/themes/contrib/` - contrib themes
- `drupal/web/profiles/contrib/` - contrib profiles
- `drupal/web/sites/*/files/` - uploaded files
- `drupal/web/sites/*/private/` - private files
- `drupal/web/sites/*/settings.local.php` - local settings
- `drupal/web/sites/*/services.local.yml` - local services

### Django:
- `django/venv/` - Python virtual environment
- `django/__pycache__/` - Python cache
- `django/**/*.pyc` - compiled Python files

## What stays in repository:

### Drupal (project customization):
- `drupal/composer.json` - dependency configuration
- `drupal/composer.lock` - locked versions
- `drupal/recipes/` - custom Drupal recipes
- `drupal/web/modules/custom/` - custom modules
- `drupal/web/themes/custom/` - custom themes
- `drupal/web/sites/*/settings.php` - main settings

### Django (application code):
- All Django application code
- Templates and static files
- Configuration files
- `requirements.txt`

### Infrastructure:
- `docker-compose.yml` - Docker orchestration
- `docker/` - Docker configurations
- Apache configurations
- README files

## Installation:

1. Install Drupal dependencies: `cd drupal && composer install`
2. Setup Python environment: `cd django && python -m venv venv`
3. Run Docker: `docker-compose up -d`

Repository now contains only necessary files!
