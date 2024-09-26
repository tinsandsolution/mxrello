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
