import os
from django.urls import path, re_path
from django.conf import settings
from django.http import Http404
from pages import views
from pages.test_views import test_middleware_config
from pages.test_views import test_middleware_config

def generate_file_based_urls():
    """
    Automatically generates URLs based on file structure in templates/pages/ folder
    """
    urlpatterns = []
    pages_dir = os.path.join(settings.BASE_DIR, 'templates', 'pages')
    
    if os.path.exists(pages_dir):
        for root, dirs, files in os.walk(pages_dir):
            for file in files:
                if file.endswith('.html'):
                    # Get relative path from pages_dir
                    rel_path = os.path.relpath(os.path.join(root, file), pages_dir)
                    # Remove .html extension
                    url_path = rel_path.replace('.html', '')
                    # Replace Windows backslashes with Unix-style forward slashes
                    url_path = url_path.replace('\\', '/')
                    
                    # Create URL pattern
                    if url_path == 'index':
                        # index.html accessible as root page
                        urlpatterns.append(path('', views.page_view, {'template_path': rel_path}))
                    else:
                        # Other pages by their path
                        urlpatterns.append(path(f'{url_path}/', views.page_view, {'template_path': rel_path}))
    
    return urlpatterns

# Main URL patterns
urlpatterns = [
    # Test middleware configuration
    path('test-middleware/', test_middleware_config),
    
    # Add automatically generated URLs
    *generate_file_based_urls(),
    
    # Catch-all pattern to handle any other URLs
    re_path(r'^(?P<path>.*)/$', views.dynamic_page_view),
]
