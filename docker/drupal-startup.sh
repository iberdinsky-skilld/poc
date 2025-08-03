#!/bin/bash

# Automated Drupal installation and setup

echo "=== Starting Drupal automatic installation ==="

# Wait for MySQL to be ready
echo "Waiting for MySQL to be ready..."
while ! php -r "try { new PDO('mysql:host=drupal_db;dbname=drupal', 'drupal', 'drupal'); echo 'OK'; } catch(Exception \$e) { exit(1); }"; do
    echo "MySQL not ready, waiting 2 seconds..."
    sleep 2
done
echo "MySQL is ready!"

# Check if Drupal is already installed
if [ ! -f "/opt/drupal/web/sites/default/settings.php" ]; then
    echo "Drupal not installed, starting installation..."
    
    # Create files directory
    mkdir -p /opt/drupal/web/sites/default/files
    chmod 777 /opt/drupal/web/sites/default/files
    
    # Create custom modules directory
    mkdir -p /opt/drupal/web/modules/custom
    
    # Install Composer dependencies  
    cd /opt/drupal
    
    # Copy composer.json from host if needed
    if [ -f "/var/www/html/composer.json" ]; then
        echo "Copying composer.json from host..."
        cp /var/www/html/composer.json .
    fi
    
    echo "Installing Drush and default_content module..."
    composer require drupal/default_content drush/drush --no-interaction
    
    # Install Drupal via drush with correct database credentials
    ./vendor/bin/drush site:install standard \
        --root=/opt/drupal/web \
        --db-url=mysql://drupal:drupal@drupal_db/drupal \
        --site-name="Django-Drupal Hybrid" \
        --account-name=admin \
        --account-pass=admin123 \
        --account-mail=admin@example.com \
        --yes
    
    echo "Drupal installed!"
    
    # Enable modules
    echo "Enabling modules..."
    ./vendor/bin/drush --root=/opt/drupal/web en default_content -y
    
    # Copy and setup custom module
    echo "Setting up custom django_content module..."
    mkdir -p /opt/drupal/web/modules/custom
    cp -r /opt/drupal/recipes/django_content /opt/drupal/web/modules/custom/ 2>/dev/null || true
    
    # Create module files if they don't exist
    cat > /opt/drupal/web/modules/custom/django_content/django_content.info.yml << 'EOF'
name: Django Content
type: module
description: Custom module with content from Django pages
core_version_requirement: ^9 || ^10 || ^11
package: Custom
dependencies:
  - default_content:default_content

default_content:
  node:
    - 4d3d0ee2-fbd9-4045-8fef-d438e538751c  # Home page
    - 043b54d2-b35a-41da-b0ae-f667e8879adf  # About page
    - b81ec9a9-d179-4405-85ba-e3e7fdaeb95f  # Services page
    - 61f3a0f8-809f-4c2b-8720-3d4ace1a436a  # Contact page
  path_alias:
    - 8c5ffa08-8f05-4cad-b2cf-bc35e954c3a5  # Home alias /
    - 585445e7-378b-46b5-8a5a-bdeb46c46ef1  # About alias /about
    - c8bce45d-eac9-47fd-9290-52009ac07e4f  # Services alias /services
    - 67f9e0d1-0441-487d-ad3f-50e653d7dfbc  # Contact alias /contact
EOF

    cat > /opt/drupal/web/modules/custom/django_content/django_content.module << 'EOF'
<?php

/**
 * @file
 * Django Content module.
 */

/**
 * Implements hook_install().
 */
function django_content_install() {
  \Drupal::messenger()->addMessage(t("Django Content module installed successfully."));
}
EOF

    # Set correct permissions
    chown -R www-data:www-data /opt/drupal/web/modules/custom/django_content
    
    # Clear cache and enable module
    ./vendor/bin/drush --root=/opt/drupal/web cache:rebuild
    ./vendor/bin/drush --root=/opt/drupal/web en django_content -y
    
    # Import content if available
    echo "Importing content..."
    ./vendor/bin/drush --root=/opt/drupal/web cache:rebuild
    
    echo "=== Drupal automatic installation completed! ==="
else
    echo "Drupal already installed, skipping installation."
fi

# Set correct file permissions
chown -R www-data:www-data /opt/drupal/web/sites/default/files
chmod -R 755 /opt/drupal/web/sites/default/files

echo "=== Starting Apache ==="
exec apache2-foreground
