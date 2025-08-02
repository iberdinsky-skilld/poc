#!/bin/bash

# Activate virtual environment
source venv/bin/activate

# Apply migrations
python manage.py migrate

# Collect static files
python manage.py collectstatic --noinput

# Start Django development server
python manage.py runserver 0.0.0.0:8000
