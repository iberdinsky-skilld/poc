#!/bin/bash

# Activate virtual environment
source venv/bin/activate

# Apply migrations
python manage.py migrate

# Collect static files
python manage.py collectstatic --noinput

# Start with gunicorn for production
gunicorn --bind 0.0.0.0:8000 myproject.wsgi:application
