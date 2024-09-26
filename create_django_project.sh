#!/bin/bash

# Set project name to the current directory name
PROJECT_NAME="mxrello"

# Create and activate virtual environment
python3 -m venv venv
source venv/bin/activate

# Install Django
pip install django

# Create Django project in the current directory
django-admin startproject $PROJECT_NAME .

# Create users app
python manage.py startapp users

# Create necessary directories
mkdir -p users/templates/users
mkdir templates

# Append additional settings to settings.py
cat << EOF >> $PROJECT_NAME/settings.py

# Additional settings
INSTALLED_APPS += ['users']

# Whitelist of allowed email domains
ALLOWED_EMAIL_DOMAINS = ['example.com', 'allowed.com']

# Set custom user model
AUTH_USER_MODEL = 'users.CustomUser'
EOF

# Create and populate project urls.py
cat << EOF > $PROJECT_NAME/urls.py
from django.contrib import admin
from django.urls import path, include

urlpatterns = [
    path('admin/', admin.site.urls),
    path('', include('users.urls')),
]
EOF

# Create and populate users/models.py
cat << EOF > users/models.py
from django.contrib.auth.models import AbstractUser
from django.db import models

class CustomUser(AbstractUser):
    email = models.EmailField(unique=True)

    def __str__(self):
        return self.email
EOF

# Create and populate users/forms.py
cat << EOF > users/forms.py
from django import forms
from django.contrib.auth.forms import UserCreationForm
from .models import CustomUser
from django.core.exceptions import ValidationError
from django.conf import settings

class CustomUserCreationForm(UserCreationForm):
    email = forms.EmailField(required=True)

    class Meta:
        model = CustomUser
        fields = ("username", "email", "password1", "password2")

    def clean_email(self):
        email = self.cleaned_data['email']
        domain = email.split('@')[-1]
        if domain not in settings.ALLOWED_EMAIL_DOMAINS:
            raise ValidationError(f"Registration is not allowed for email addresses from {domain}")
        return email
EOF

# Create and populate users/views.py
cat << EOF > users/views.py
from django.contrib.auth import login
from django.shortcuts import render, redirect
from .forms import CustomUserCreationForm

def signup(request):
    if request.method == 'POST':
        form = CustomUserCreationForm(request.POST)
        if form.is_valid():
            user = form.save()
            login(request, user)
            return redirect('home')  # Redirect to home page after signup
    else:
        form = CustomUserCreationForm()
    return render(request, 'users/signup.html', {'form': form})

def home(request):
    return render(request, 'users/home.html')
EOF

# Create and populate users/urls.py
cat << EOF > users/urls.py
from django.urls import path
from . import views
from django.contrib.auth import views as auth_views

urlpatterns = [
    path('', views.home, name='home'),
    path('signup/', views.signup, name='signup'),
    path('login/', auth_views.LoginView.as_view(template_name='users/login.html'), name='login'),
    path('logout/', auth_views.LogoutView.as_view(), name='logout'),
]
EOF

# Create and populate users/templates/users/signup.html
cat << EOF > users/templates/users/signup.html
{% extends 'base.html' %}

{% block content %}
  <h2>Sign up</h2>
  <form method="post">
    {% csrf_token %}
    {{ form.as_p }}
    <button type="submit">Sign up</button>
  </form>
{% endblock %}
EOF

# Create and populate users/templates/users/login.html
cat << EOF > users/templates/users/login.html
{% extends 'base.html' %}

{% block content %}
  <h2>Log in</h2>
  <form method="post">
    {% csrf_token %}
    {{ form.as_p }}
    <button type="submit">Log in</button>
  </form>
{% endblock %}
EOF

# Create and populate users/templates/users/home.html
cat << EOF > users/templates/users/home.html
{% extends 'base.html' %}

{% block content %}
  <h2>Welcome{% if user.is_authenticated %}, {{ user.username }}{% endif %}!</h2>
  {% if user.is_authenticated %}
    <p>You are logged in.</p>
    <a href="{% url 'logout' %}">Log out</a>
  {% else %}
    <p>You are not logged in.</p>
    <a href="{% url 'login' %}">Log in</a> or <a href="{% url 'signup' %}">Sign up</a>
  {% endif %}
{% endblock %}
EOF

# Create and populate templates/base.html
cat << EOF > templates/base.html
<!DOCTYPE html>
<html>
<head>
    <title>{% block title %}My Site{% endblock %}</title>
</head>
<body>
    <main>
        {% block content %}
        {% endblock %}
    </main>
</body>
</html>
EOF

# Create requirements.txt
pip freeze > requirements.txt

echo "Django project structure created and populated successfully!"

# List the created structure
tree

# Instructions for next steps
echo "
Next steps:
1. Review and adjust the settings in $PROJECT_NAME/settings.py
2. Run migrations:
   python manage.py makemigrations users
   python manage.py migrate
3. Create a superuser:
   python manage.py createsuperuser
4. Run the development server:
   python manage.py runserver
"