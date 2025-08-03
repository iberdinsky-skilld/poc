import yaml
import requests
from django.http import HttpResponse
from django.conf import settings
import os

class DrupalHybridMiddleware:
    """
    Middleware for Django + Drupal hybrid routing.
    Redirects certain requests to Drupal based on ready_pages.yml configuration.
    """

    def __init__(self, get_response):
        self.get_response = get_response
        self.ready_pages = self.load_ready_pages()
        self.drupal_url = 'http://poc-drupal-1'

    def load_ready_pages(self):
        """Load the ready_pages.yml configuration"""
        config_path = os.path.join(settings.BASE_DIR, 'ready_pages.yml')
        try:
            with open(config_path, 'r', encoding='utf-8') as file:
                config = yaml.safe_load(file)
                return config.get('drupal_pages', [])
        except (FileNotFoundError, yaml.YAMLError):
            return []

    def __call__(self, request):
        # Check if the requested path should be handled by Drupal
        current_path = request.path

        # Skip middleware for static files and admin paths
        if any(current_path.startswith(path) for path in [
            '/static/', '/media/', '/admin/', '/sites/', '/core/', '/modules/', '/themes/',
            '/favicon.ico', '/robots.txt'
        ]) or any(current_path.endswith(ext) for ext in [
            '.css', '.js', '.woff', '.woff2', '.png', '.jpg', '.gif', '.ico', '.svg'
        ]):
            # For Drupal static files, try to proxy to Drupal first
            if current_path.startswith(('/sites/', '/core/', '/modules/', '/themes/')) or current_path.endswith(('.css', '.js', '.woff', '.woff2')):
                try:
                    drupal_response = requests.get(
                        f"{self.drupal_url}{current_path}",
                        timeout=5,
                        params=request.GET,
                        allow_redirects=False
                    )
                    if drupal_response.status_code == 200:
                        response = HttpResponse(
                            content=drupal_response.content,
                            status=drupal_response.status_code,
                            content_type=drupal_response.headers.get('Content-Type', 'text/html')
                        )
                        return response
                except requests.RequestException:
                    pass

            # Fall back to Django for other static files
            response = self.get_response(request)
            return response

        if current_path in self.ready_pages:
            try:
                # Forward request to Drupal
                drupal_response = requests.get(
                    f"{self.drupal_url}{current_path}",
                    timeout=10,
                    headers={'User-Agent': request.META.get('HTTP_USER_AGENT', '')},
                    allow_redirects=False
                )

                # Return Drupal's response
                response = HttpResponse(
                    content=drupal_response.content,
                    status=drupal_response.status_code,
                    content_type=drupal_response.headers.get('Content-Type', 'text/html')
                )

                # Copy important headers
                for header in ['Set-Cookie', 'Location', 'Cache-Control']:
                    if header in drupal_response.headers:
                        response[header] = drupal_response.headers[header]

                return response

            except requests.RequestException as e:
                # If Drupal is not available, fall back to Django
                pass

        # Continue with Django processing
        response = self.get_response(request)
        return response
