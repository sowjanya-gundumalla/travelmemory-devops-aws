# TravelMemory - Terraform & Ansible Deployment on AWS

## Overview
This project demonstrates infrastructure provisioning and configuration management for the TravelMemory MERN stack application using Terraform and Ansible on AWS.

## Architecture
Internet → Web Server (Public Subnet) → MongoDB (Private Subnet)
↑
Application Load Balancer

### Infrastructure Flow
- User traffic hits the web server EC2 instance in the public subnet
- Node.js backend runs on port 3000, managed by PM2
- Nginx acts as reverse proxy routing port 80 → 3000
- MongoDB runs on the DB server in the private subnet
- Private subnet has no direct internet access, outbound only via NAT Gateway

## Tech Stack
- **Frontend:** React
- **Backend:** Node.js, Express.js
- **Database:** MongoDB
- **IaC:** Terraform
- **Configuration Management:** Ansible
- **Process Manager:** PM2
- **Reverse Proxy:** Nginx
- **Cloud:** AWS (VPC, EC2, IGW, NAT Gateway, Security Groups)

## Infrastructure Details

| Resource | Details |
|---|---|
| VPC CIDR | 10.0.0.0/16 |
| Public Subnet | 10.0.1.0/24 (ap-south-1a) |
| Private Subnet | 10.0.2.0/24 (ap-south-1a) |
| Web Server | t3.small, Ubuntu 24.04, Public IP: 13.207.188.131 |
| DB Server | t3.small, Ubuntu 24.04, Private IP: 10.0.2.221 |
| Region | ap-south-1 |

## Security Groups

### Web Server SG
| Port | Protocol | Source | Purpose |
|---|---|---|---|
| 22 | TCP | 0.0.0.0/0 | SSH |
| 80 | TCP | 0.0.0.0/0 | HTTP |
| 3000 | TCP | 0.0.0.0/0 | Node.js |

### DB Server SG
| Port | Protocol | Source | Purpose |
|---|---|---|---|
| 22 | TCP | Web Server SG | SSH via jump host |
| 27017 | TCP | Web Server SG | MongoDB |

## Project Structure

terraform-ansible/
├── terraform/
│   ├── main.tf           # AWS provider configuration
│   ├── variables.tf      # Input variables
│   ├── vpc.tf            # VPC, subnets, IGW, NAT, route tables
│   ├── security_groups.tf # Web and DB security groups
│   ├── ec2.tf            # EC2 instances
│   └── outputs.tf        # Output values
├── ansible/
│   ├── inventory/
│   │   └── hosts.ini     # Ansible inventory with jump host config
│   └── playbooks/
│       ├── webserver.yml # Node.js, PM2, Nginx setup
│       └── database.yml  # MongoDB setup
└── screenshots/

## Part 1: Terraform - Infrastructure Setup

### Prerequisites
- AWS CLI configured (`aws configure`)
- Terraform installed
- EC2 key pair available

### Steps

#### 1. Initialize Terraform
```bash
cd terraform-ansible/terraform
terraform init
```

#### 2. Review Plan
```bash
terraform plan
```
Expected: 14 resources to create

#### 3. Apply Infrastructure
```bash
terraform apply
```
Type `yes` when prompted. Takes ~3 minutes (NAT Gateway takes longest).

#### 4. Note Outputs

web_server_public_ip  = "13.207.188.131"
web_server_public_dns = "ec2-13-207-188-131.ap-south-1.compute.amazonaws.com"
db_server_private_ip  = "10.0.2.221"

## Part 2: Ansible - Configuration and Deployment

### Prerequisites
- Ansible installed (`ansible --version`)
- PEM key accessible
- Terraform apply completed

### Steps

#### 1. Copy PEM key to web server (for DB jump host access)
```bash
scp -i ~/sowjanya-cicd.pem ~/sowjanya-cicd.pem ubuntu@13.207.188.131:~/.ssh/sowjanya-cicd.pem
ssh -i ~/sowjanya-cicd.pem ubuntu@13.207.188.131 "chmod 600 ~/.ssh/sowjanya-cicd.pem"
```

#### 2. Test connectivity
```bash
ansible webserver -i ansible/inventory/hosts.ini -m ping
```

#### 3. Run Database playbook
```bash
ansible-playbook -i ansible/inventory/hosts.ini ansible/playbooks/database.yml
```
Installs and configures MongoDB 7.0, binds to all interfaces.

#### 4. Run Web Server playbook
```bash
ansible-playbook -i ansible/inventory/hosts.ini ansible/playbooks/webserver.yml
```
Installs Node.js 18, PM2, Nginx, clones repo, configures reverse proxy.

#### 5. Verify deployment
```bash
curl http://13.207.188.131/trip
# Expected: []
```

## Verification

### PM2 Process
```bash
ssh -i ~/sowjanya-cicd.pem ubuntu@13.207.188.131 "pm2 list"
```

### MongoDB Status
```bash
ssh -i ~/sowjanya-cicd.pem ubuntu@13.207.188.131 \
  "ssh -i ~/.ssh/sowjanya-cicd.pem ubuntu@10.0.2.221 'sudo systemctl status mongod'"
```

### API Test
```bash
curl http://13.207.188.131/trip
```

## Key Outcomes
- Provisioned complete AWS network infrastructure using Terraform
- Deployed MongoDB on private subnet using Ansible
- Deployed Node.js backend with PM2 and Nginx on public subnet using Ansible
- Established secure communication between web and DB servers via security groups
- Application accessible via public IP with Nginx reverse proxy

## Cleanup
```bash
cd terraform-ansible/terraform
terraform destroy
```
Type `yes` when prompted. Destroys all 14 resources.

## Application Source
https://github.com/UnpredictablePrashant/TravelMemory