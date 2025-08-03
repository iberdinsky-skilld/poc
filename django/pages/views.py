import os
import django
from django.shortcuts import render
from django.http import Http404
from django.conf import settings

def page_view(request, template_path):
    """
    Renders a page by given template path
    """
    template_full_path = f'pages/{template_path}'
    
    # Check if file exists
    file_path = os.path.join(settings.BASE_DIR, 'templates', template_full_path)
    if not os.path.exists(file_path):
        raise Http404(f"Page not found: {template_path}")
    
    context = {
        'django_version': django.get_version()
    }
    return render(request, template_full_path, context)

def dynamic_page_view(request, path):
    """
    Dynamically searches for a page by URL path
    """
    # Remove trailing slash if present
    path = path.strip('/')
    
    # If path is empty, look for index
    if not path:
        path = 'index'
    
    # Form template path
    template_path = f'pages/{path}.html'
    template_full_path = os.path.join(settings.BASE_DIR, 'templates', template_path)
    
    context = {
        'django_version': django.get_version()
    }
    
    # Check if file exists
    if os.path.exists(template_full_path):
        return render(request, template_path, context)
    
    # If file not found, try to find index.html in folder
    index_template_path = f'pages/{path}/index.html'
    index_full_path = os.path.join(settings.BASE_DIR, 'templates', index_template_path)
    
    if os.path.exists(index_full_path):
        return render(request, index_template_path, context)
    
    # If nothing found, raise 404
    raise Http404(f"Page not found: {path}")
