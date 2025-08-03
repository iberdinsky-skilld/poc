from django.http import JsonResponse
import yaml
import os
from django.conf import settings

def test_middleware_config(request):
    """Test view to check middleware configuration"""
    config_path = os.path.join(settings.BASE_DIR, 'ready_pages.yml')
    try:
        with open(config_path, 'r', encoding='utf-8') as file:
            config = yaml.safe_load(file)
            return JsonResponse({
                'config_loaded': True,
                'config_path': config_path,
                'drupal_pages': config.get('drupal_pages', []),
                'request_path': request.path
            })
    except Exception as e:
        return JsonResponse({
            'config_loaded': False,
            'error': str(e),
            'config_path': config_path,
            'request_path': request.path
        })
