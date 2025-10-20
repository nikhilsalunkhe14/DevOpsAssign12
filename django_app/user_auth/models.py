# In django_app/user_auth/models.py
from django.db import models

# As required by the PDF
class Login(models.Model):
    username = models.CharField(max_length=100, unique=True) # e.g., ITA700
    password = models.CharField(max_length=100) # e.g., 2022PE0000

    def __str__(self):
        return self.username