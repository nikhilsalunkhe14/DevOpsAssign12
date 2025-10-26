AWS DevOps Automation Project
Project Overview
This project demonstrates a complete DevOps pipeline that automates the deployment of a Django web application with a PostgreSQL database on AWS EC2 instances.
It uses Terraform for infrastructure provisioning, Ansible for configuration management, Docker for containerization, Docker Swarm for orchestration, and GitHub Actions for CI/CD automation.

| Tool / Technology         | Purpose                                                    |
| ------------------------- | ---------------------------------------------------------- |
| Terraform                 | Infrastructure as Code (IaC) for AWS resource provisioning |
| Ansible                   | Server configuration and Docker installation               |
| Docker & Docker Swarm     | Containerization and orchestration                         |
| Django + PostgreSQL       | Web application and database                               |
| GitHub Actions            | CI/CD pipeline automation                                  |
| WSL (Ubuntu)              | Local environment for Ansible and Linux-based tools        |

Project Structure
aws-devops-project/
│
├── terraform/              # Infrastructure provisioning on AWS
│   ├── provider.tf
│   ├── main.tf
│   ├── outputs.tf
│
├── ansible/                # Configuration management
│   ├── inventory.ini
│   ├── install-docker.yml
│   ├── swarm-init.yml
│
├── docker/                 # Containerization and orchestration
│   ├── Dockerfile
│   ├── docker-compose.yml
│
├── django_app/             # Django web app
│   ├── main_project/
│   ├── user_auth/
│   ├── requirements.txt
│
├── scripts/
│   └── bootstrap.sh        # One-click setup automation
│
└── .github/workflows/
    └── deploy.yml          # CI/CD pipeline configuration


<img width="1212" height="611" alt="image" src="https://github.com/user-attachments/assets/6f19f987-56ce-49e7-8da9-331eb254d3e8" />


✅ Final Outcome

Django app deployed successfully on AWS using fully automated DevOps pipeline.
Infrastructure → Configuration → Deployment → CI/CD achieved end-to-end.
Verified live via manager node public IP.
