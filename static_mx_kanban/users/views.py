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
