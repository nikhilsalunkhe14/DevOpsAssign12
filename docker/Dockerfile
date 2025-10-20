# docker/Dockerfile

# Start from an official Python image
FROM python:3.11-slim

# Set environment variables for Python
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Set the working directory inside the container
WORKDIR /app

# Copy the requirements file and install dependencies
COPY django_app/requirements.txt .
RUN pip install -r requirements.txt

# Copy the entire Django project code into the container
COPY django_app/ .

# Expose port 8000 so the Swarm can see the app
EXPOSE 8000

# The command to run your app using gunicorn
# This is a production-ready server, not the test server
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "main_project.wsgi:application"]