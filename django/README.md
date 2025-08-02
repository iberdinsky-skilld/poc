# Django with Dynamic File-based Routing

A simple Django project that automatically creates URLs based on file structure in the `templates/pages/` folder.

## 🚀 Quick Start

### 1. Activate virtual environment
```bash
source venv/bin/activate
```

### 2. Install dependencies
```bash
pip install -r requirements.txt
```

### 3. Run the server
```bash
python manage.py runserver
```

The site will be available at: http://127.0.0.1:8000/

## 📁 How File-based Routing Works

### Working Principle
The system automatically scans the `templates/pages/` folder and creates URL routes for all found HTML files:

```
templates/pages/
├── index.html              → /                 (root page)
├── about.html              → /about/
├── contact.html            → /contact/
├── services.html           → /services/
└── blog/
    ├── index.html          → /blog/
    ├── first-post.html     → /blog/first-post/
    └── my-article.html     → /blog/my-article/
```

### Features
- **index.html** in the root of `pages/` folder becomes the main page (`/`)
- **index.html** in any subfolder becomes the page of that folder
- Unlimited folder nesting is supported
- URLs are automatically generated without `.html` extension

## 📝 Adding New Pages

### Simple page
1. Create file `templates/pages/new-page.html`
2. Page will automatically become available at URL `/new-page/`

### Page in subsection
1. Create folder `templates/pages/section/`
2. Add file `templates/pages/section/page.html`
3. Page will be available at URL `/section/page/`

### Template structure example
```html
{% extends 'base.html' %}

{% block title %}Page Title{% endblock %}

{% block content %}
<h1>Page Content</h1>
<p>Your content here...</p>
{% endblock %}
```

## 🛠 Project Structure

```
django/
├── myproject/              # Django settings
│   ├── settings.py         # Main settings (no admin and API)
│   ├── urls.py             # Dynamic URL generation
│   └── wsgi.py
├── pages/                  # Django app for pages
│   ├── views.py            # Dynamic page handlers
│   └── apps.py
├── templates/              # Templates
│   ├── base.html           # Base template
│   └── pages/              # Site pages
│       ├── index.html      # Home page
│       ├── about.html      # About page
│       ├── contact.html    # Contact
│       ├── services.html   # Services
│       └── blog/           # Blog
│           ├── index.html
│           └── first-post.html
├── static/                 # Static files (CSS, JS, images)
├── venv/                   # Virtual environment
├── manage.py               # Django management script
├── requirements.txt        # Python dependencies
└── .env                    # Environment variables
```

## ⚙️ Configuration

### Environment variables (.env)
- `DEBUG` - Debug mode (True/False)
- `SECRET_KEY` - Django secret key

### Main configuration features
- Removed admin and API (django.contrib.admin, DRF)
- Uses SQLite (no database setup required)
- Simplified middleware
- Automatic URL generation

## 🎯 Usage Examples

### Adding new blog article
1. Create file `templates/pages/blog/my-new-article.html`
2. Fill with content using base template
3. Article will automatically become available at `/blog/my-new-article/`

### Creating new section
1. Create folder `templates/pages/products/`
2. Add `templates/pages/products/index.html` for section main page
3. Add individual product pages to this folder

## 🔧 Extending Functionality

Project can be easily extended:
- Adding contact forms
- CMS integration
- Adding comment system
- Markdown file support
- Multilingual support

## 💡 Approach Benefits

- **Simplicity**: No need to configure URL patterns
- **Intuitiveness**: URL structure reflects file structure  
- **Speed**: Instant addition of new pages
- **Maintainability**: Easy renaming and reorganization
- **Cleanliness**: Minimal code, maximum functionality
