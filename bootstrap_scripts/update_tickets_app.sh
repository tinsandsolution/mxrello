#!/bin/bash

# ... (previous content remains the same)

cd ..

# Update views.py content
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
            tickets_data = json.load(file)
        
        # Process the tickets data
        processed_tickets = []
        for ticket in tickets_data:
            processed_ticket = {}
            for item in ticket:
                processed_ticket[item['key']] = item['value']
            processed_tickets.append(processed_ticket)
        
        return render(request, 'tickets/unfinished_tickets.html', {'tickets': processed_tickets})
    
    except FileNotFoundError:
        return JsonResponse({'error': 'Tickets file not found'}, status=404)
    except json.JSONDecodeError:
        return JsonResponse({'error': 'Invalid JSON in tickets file'}, status=500)
EOL

# Update unfinished_tickets.html template
cat > tickets/templates/tickets/unfinished_tickets.html << EOL
{% extends 'base.html' %}

{% block content %}
<h1>Unfinished Tickets</h1>
<ul>
{% for ticket in tickets %}
    <li>
        <strong>{{ ticket.title }}</strong> - {{ ticket.status }}<br>
        Priority: {{ ticket.priority }}<br>
        Due Date: {{ ticket.dueDate|date:"F j, Y" }}<br>
        Assignees: {{ ticket.assignees }}<br>
        <a href="{{ ticket.url }}" target="_blank">View in MaintainX</a>
    </li>
{% empty %}
    <li>No unfinished tickets found.</li>
{% endfor %}
</ul>
{% endblock %}
EOL

echo "Tickets app has been updated to handle the new data structure!"