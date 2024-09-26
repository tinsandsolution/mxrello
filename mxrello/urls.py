from django.contrib import admin
from django.urls import path, include, include

urlpatterns = [
    path('tickets/', include('tickets.urls')),
    path('admin/', admin.site.urls),
    path('', include('users.urls')),
]
