from django.urls import path
from . import views

urlpatterns = [
    path('unfinished/', views.unfinished_tickets, name='unfinished_tickets'),
]
