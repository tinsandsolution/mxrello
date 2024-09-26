from django.contrib.auth import login
from django.shortcuts import render, redirect
from django.contrib.auth.decorators import login_required
from .forms import CustomUserCreationForm

def signup(request):
    if request.method == 'POST':
        form = CustomUserCreationForm(request.POST)
        if form.is_valid():
            user = form.save()
            login(request, user)
            return redirect('hello_world')  # Redirect to hello world page after signup
    else:
        form = CustomUserCreationForm()
    return render(request, 'users/signup.html', {'form': form})

def home(request):
    return render(request, 'users/home.html')

@login_required
def hello_world(request):
    return render(request, 'users/hello_world.html')