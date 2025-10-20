# In terraform/main.tf

# First, find the latest official Ubuntu 20.04 AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical's official owner ID
}

# Create a security group to allow the correct ports
resource "aws_security_group" "devops_sg" {
  name        = "devops_sg"
  description = "Allow SSH, HTTP, HTTPS, and Docker Swarm ports"

  # SSH from anywhere (for you to connect)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP from anywhere (for the web app)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Docker Swarm manager port
  ingress {
    from_port   = 2377
    to_port     = 2377
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Docker Swarm node communication
  ingress {
    from_port   = 7946
    to_port     = 7946
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 7946
    to_port     = 7946
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Docker Swarm overlay network
  ingress {
    from_port   = 4789
    to_port     = 4789
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "DevOps SG"
  }
}

# Create the 2 Swarm nodes (Manager, WorkerA)
resource "aws_instance" "swarm_nodes" {
  for_each = toset(["manager", "workerA"]) # <-- CHANGED: Only 2 servers now

  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro" # Free-tier eligible
  key_name      = "ubuntupass" # Your key!
  security_groups = [aws_security_group.devops_sg.name]

  tags = {
    Name = each.key
  }
}

# Create and attach Elastic IPs to the 2 Swarm nodes
resource "aws_eip" "eips" {
  for_each = aws_instance.swarm_nodes
  instance = each.value.id

  tags = {
    Name = "${each.key}-EIP"
  }
}