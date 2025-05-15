- MERN Stack Blog App Deployment on AWS using Terraform & Ansible

Author: SDA2012-Raghad  
Assignment: Infrastructure Bootcamp - Week 11  
  
- Overview

This project demonstrates deploying a MERN Stack Blog Application on AWS using -Terraform- for infrastructure provisioning and -Ansible- for backend server automation. The architecture includes:

- **EC2 (Ubuntu 22.04)** for backend (Node.js + Express)
- **S3 (Static Website Hosting)** for frontend (React)
- **MongoDB Atlas** as a cloud database
- **S3 Bucket** for media uploads
- **IAM User** for secure S3 media access

---

## Architecture Diagram

![Architecture Diagram](./screenshots/architecture.png)

---

## Tools & Technologies Used

- AWS EC2
- AWS S3
- MongoDB Atlas
- Terraform
- Ansible
- PM2
- Node.js / React
- Git + GitHub

## Implementation

### 1. Folder Structure

```
mern-deployment/
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── init.sh
│   └── frontend-policy.json
├── ansible/
│   ├── inventory
│   ├── backend-playbook.yml
│   └── roles/
│       └── backend/
│           ├── tasks/
│           ├── templates/
│           └── vars/
└── screenshots/


### 2. Terraform - Infrastructure Setup

#### Files Created:
- `main.tf`: Defines EC2, S3 buckets, IAM user, security group
- `variables.tf`: Declares input variables (if needed)
- `outputs.tf`: Displays EC2 IP and IAM credentials
- `init.sh`: User data script to auto-install Node.js & PM2

#### Commands Used:
```bash
cd terraform
terraform init
terraform apply
```

#### Resources Created:
- EC2 (t3.micro, Ubuntu 22.04)
- Security Group (Ports 22, 80, 5000)
- S3 Buckets:
  - `raghad-frontend-bucket`
  - `raghad-media-bucket` (with CORS and private access)
- IAM User with policy for S3 media
- Outputs for:
  - EC2 Public IP
  - S3 IAM credentials

---

### 3. MongoDB Atlas Setup

Steps done manually on MongoDB website:

- Created free-tier cluster
- Whitelisted EC2 IP
- Created DB user
- Retrieved connection string:
  ```
  mongodb+srv://USERNAME:PASSWORD@cluster.mongodb.net/blog-app
  ```

Used this in `.env` file for backend.



### 4. Ansible - Backend Provisioning

#### Folder Setup:

ansible/
├── inventory             # Contains EC2 IP
├── backend-playbook.yml # Main playbook
└── roles/backend/
    ├── tasks/main.yml   # Clone repo, install packages, configure app
    ├── templates/.env.j2 # Template for .env file
    └── vars/main.yml    # Contains sensitive data (MongoDB, S3 keys)


#### Commands Used:
```bash
cd ansible
ansible-playbook -i inventory backend-playbook.yml
```

#### Actions Performed:
- Cloned repo from GitHub
- Created `.env` using template
- Installed Node.js via NVM
- Installed PM2 globally
- Started backend with PM2

---

### 5. Frontend Setup & Deployment

#### Inside EC2:

```bash
cd ~/blog-app/frontend
cat > .env <<EOF
VITE_BASE_URL=http://<EC2-PUBLIC-IP>:5000/api
VITE_MEDIA_BASE_URL=https://<your-media-bucket>.s3.eu-north-1.amazonaws.com
EOF

npm install -g pnpm
pnpm install
pnpm run build
```

#### Upload to S3:

```bash
aws configure  # Enter IAM user credentials from Terraform output
aws s3 sync dist/ s3://<frontend-bucket-name>/
``
---

## Cleanup (Important)

After testing, I cleaned up all the resources:

```bash
terraform destroy
```

Also removed:
- MongoDB users & IP access
- S3 credentials from EC2
- IAM access keys

---

## Notes

- All sensitive values (MongoDB credentials, IAM keys) were kept out of the GitHub repository.
- `.env` files were generated dynamically via Ansible templates.
- The infrastructure is reproducible with a single Terraform & Ansible execution.

---

## Done by:
**Raghad**
