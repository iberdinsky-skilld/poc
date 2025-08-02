#!/bin/bash

# Script to create Django-like content structure in Drupal
# Run this after applying the django_structure recipe

echo "Creating Django-like content in Drupal..."

# Create Home Page
drush node:create page --title="Home Page" --body="<h1>Welcome!</h1><p>This is the home page recreated from Django structure in Drupal.</p><h2>Available Pages:</h2><ul><li><a href="/about">About</a></li><li><a href="/contact">Contact</a></li><li><a href="/services">Services</a></li><li><a href="/blog">Blog</a></li></ul><p>This structure mirrors the original Django file-based routing system!</p>" --status=1 --promote=1

# Create About Page  
drush node:create page --title="About Us" --body="<h1>About Our Company</h1><p>This is the about page, recreated from the Django template structure.</p><p>We are a forward-thinking company that bridges Django and Drupal technologies.</p>" --status=1

# Create Contact Page
drush node:create page --title="Contact Us" --body="<h1>Contact Information</h1><p>Get in touch with us!</p><p>This page structure matches the original Django contact template.</p><h2>Contact Details:</h2><ul><li>Email: contact@example.com</li><li>Phone: +1 (555) 123-4567</li><li>Address: 123 Tech Street, Digital City</li></ul>" --status=1

# Create Services Page
drush node:create page --title="Our Services" --body="<h1>Our Services</h1><p>We offer comprehensive web development solutions.</p><h2>Service Areas:</h2><ul><li>Django Development</li><li>Drupal Development</li><li>Hybrid System Integration</li><li>Database Design</li><li>DevOps and Deployment</li></ul>" --status=1

# Create Blog Posts
drush node:create blog_post --title="First Blog Post" --body="<h1>Welcome to Our Blog</h1><p>This is our first blog post, recreating the Django blog structure in Drupal.</p><p>We'll be sharing insights about web development, Django, Drupal, and hybrid systems.</p>" --status=1

drush node:create blog_post --title="Django to Drupal Migration" --body="<h1>Migrating from Django to Drupal</h1><p>In this post, we explore the process of migrating content and structure from Django to Drupal.</p><p>Key considerations include content types, URL structures, and maintaining SEO value.</p>" --status=1

# Set up URL aliases
drush path:create node/1 /
drush path:create node/2 /about  
drush path:create node/3 /contact
drush path:create node/4 /services
drush path:create node/5 /blog/first-post
drush path:create node/6 /blog/django-to-drupal-migration

echo "Content creation completed! Visit your site to see the Django-like structure."
