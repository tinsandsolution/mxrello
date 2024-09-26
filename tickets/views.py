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
