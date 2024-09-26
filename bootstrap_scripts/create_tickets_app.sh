#!/bin/bash

cd ..

# Create the new 'tickets' app
python manage.py startapp tickets

# Add 'tickets' to INSTALLED_APPS
sed -i "s/INSTALLED_APPS = \[/INSTALLED_APPS = [\n    'tickets',/" mxrello/settings.py

# Create views.py content
cat > tickets/views.py << EOL
import json
import os
from django.conf import settings
from django.shortcuts import render
from django.http import JsonResponse

def unfinished_tickets(request):
    json_file_path = os.path.join(settings.BASE_DIR, 'unfinished_tickets.json')
    
    try:
        with open(json_file_path, 'r') as file:
            tickets = json.load(file)
        
        return render(request, 'tickets/unfinished_tickets.html', {'tickets': tickets})
    
    except FileNotFoundError:
        return JsonResponse({'error': 'Tickets file not found'}, status=404)
    except json.JSONDecodeError:
        return JsonResponse({'error': 'Invalid JSON in tickets file'}, status=500)
EOL

# Create templates directory
mkdir -p tickets/templates/tickets

# Create unfinished_tickets.html template
cat > tickets/templates/tickets/unfinished_tickets.html << EOL
{% extends 'base.html' %}

{% block content %}
<h1>Unfinished Tickets</h1>
<ul>
{% for ticket in tickets %}
    <li>{{ ticket.title }} - {{ ticket.status }}</li>
{% empty %}
    <li>No unfinished tickets found.</li>
{% endfor %}
</ul>
{% endblock %}
EOL

# Create urls.py for the tickets app
cat > tickets/urls.py << EOL
from django.urls import path
from . import views

urlpatterns = [
    path('unfinished/', views.unfinished_tickets, name='unfinished_tickets'),
]
EOL

# Update main project urls.py
sed -i "/from django.urls import path/s/path/path, include/" mxrello/urls.py
sed -i "/urlpatterns = \[/a\    path('tickets/', include('tickets.urls'))," mxrello/urls.py

# Add link to base.html
sed -i "/<\/body>/i\    <a href=\"{% url 'unfinished_tickets' %}\">Unfinished Tickets</a>" templates/base.html

echo "Tickets app has been created and configured successfully!"