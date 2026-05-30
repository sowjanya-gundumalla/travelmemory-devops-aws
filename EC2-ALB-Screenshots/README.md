# Travel Memory Application Deployment on AWS

## Overview

This project demonstrates the deployment of the **Travel Memory** MERN stack application on Amazon Web Services (AWS). The application was configured using a scalable cloud architecture with multiple EC2 instances behind an Application Load Balancer and connected to a custom domain via Cloudflare.

The deployment includes backend configuration, frontend integration, reverse proxy setup, horizontal scaling, and DNS configuration.

---

## Architecture Summary

The deployed system follows this flow:

```
User → Cloudflare (DNS) → Application Load Balancer → EC2 Instances → MongoDB Atlas
```

* User traffic is routed via Cloudflare DNS.
* An AWS Application Load Balancer distributes traffic across multiple EC2 instances.
* Each EC2 instance runs the full MERN application stack.
* MongoDB Atlas serves as the centralized cloud database.

The architecture diagram is included.

---

## Tech Stack

### Frontend

* React

### Backend

* Node.js
* Express.js

### Database

* MongoDB Atlas

### Server & Process Management

* Nginx (Reverse Proxy)
* PM2 (Process Manager)

### Cloud Infrastructure

* AWS EC2
* AWS Application Load Balancer (ALB)
* AWS Target Groups
* Amazon Machine Image (AMI)

### DNS & Domain

* Cloudflare
* GoDaddy (Domain Registrar)

---

## Backend Deployment

### 1. Repository Setup

* Cloned the Travel Memory repository on the EC2 instance.
* Installed all backend dependencies using `npm install`.

### 2. Environment Configuration

* Created a `.env` file with:

  * `PORT`
  * `MONGO_URI`
  * `JWT_SECRET`
* Connected backend to MongoDB Atlas.

### 3. Backend Execution

* Started the backend server.
* Verified functionality via API endpoint testing.
* Configured PM2 to manage the Node.js process.
* Enabled PM2 startup for persistence across reboots.

### 4. Reverse Proxy Configuration

* Installed and configured Nginx.
* Routed incoming HTTP traffic from port 80 to the backend service.
* Verified API access through Nginx.

---

## Frontend Deployment

### 1. API Configuration

* Configured frontend to connect to the deployed backend using environment variables.

### 2. Production Build

* Installed frontend dependencies.
* Generated a production build using:

  ```
  npm run build
  ```

### 3. Nginx Integration

* Deployed the build files to the Nginx web directory.
* Restarted Nginx to serve the React application.
* Verified frontend accessibility via EC2 public IP.

---

## Horizontal Scaling and Load Balancing

### 1. AMI Creation

* Created an Amazon Machine Image (AMI) from the configured EC2 instance.

### 2. Launching Multiple Instances

* Launched multiple EC2 instances from the custom AMI.
* Ensured identical configuration across instances.

### 3. Target Group Configuration

* Created a Target Group.
* Registered EC2 instances.
* Verified health checks were passing.

### 4. Application Load Balancer Setup

* Created an Application Load Balancer.
* Configured HTTP listener on port 80.
* Attached the Load Balancer to the Target Group.
* Verified traffic distribution across instances.

---

## Domain Configuration with Cloudflare

### 1. Domain Onboarding

* Added the custom domain to Cloudflare.
* Updated nameservers in GoDaddy to Cloudflare nameservers.

### 2. DNS Records Configuration

* Configured CNAME record:

  * `www` → Application Load Balancer DNS
* Configured A record:

  * Root domain → EC2 public IP

### 3. Verification

* Confirmed domain resolution.
* Verified application accessibility through custom domain.

---

## Application Access

**Custom Domain:**

```
http://studiomoonbear.com
```

**Load Balancer Endpoint:**

```
http://travelmemory-alb-1207660565.ap-south-1.elb.amazonaws.com
```

---

## Repository Structure

```
.
├── README.md
├── architecture-diagram.png
└── screenshots/
    ├── backend-setup.png
    ├── pm2-running.png
    ├── nginx-config.png
    ├── frontend-build.png
    ├── target-group.png
    ├── alb-active.png
    ├── cloudflare-dns.png
    └── custom-domain.png
```

---

## Key Outcomes

* Successfully deployed a full MERN stack application on AWS.
* Implemented reverse proxy using Nginx.
* Managed backend processes using PM2.
* Achieved horizontal scaling with multiple EC2 instances.
* Implemented load balancing using AWS ALB.
* Configured custom domain using Cloudflare.
* Demonstrated production-ready cloud deployment architecture.

---

## Conclusion

The Travel Memory application was successfully deployed using a scalable and production-oriented cloud architecture. The system integrates AWS infrastructure, DNS management, reverse proxy configuration, and load balancing to ensure availability and extensibility.

This project demonstrates practical knowledge of cloud deployment, infrastructure configuration, and scalable application design.

---

 
