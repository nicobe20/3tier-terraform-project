# AWS 3-Tier Architecture with Terraform 🏗️

Deploy a production-ready 3-tier architecture on AWS using Terraform with zero manual setup required!

## 📋 Table of Contents
- [Architecture Overview](#architecture-overview)
- [What Gets Deployed](#what-gets-deployed)
- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Project Structure](#project-structure)
- [Configuration](#configuration)
- [Deployment Steps](#deployment-steps)
- [After Deployment](#after-deployment)
- [Cost Estimate](#cost-estimate)
- [Troubleshooting](#troubleshooting)
- [Cleanup](#cleanup)

---

## 🏛️ Architecture Overview

This project deploys a highly available 3-tier architecture on AWS:

```
                           ┌─────────────┐
                           │   Internet  │
                           └──────┬──────┘
                                  │
                          ┌───────▼────────┐
                          │ Internet Gateway│
                          └───────┬─────────┘
                                  │
                    ┌─────────────▼──────────────┐
                    │   Web Tier ALB (Public)    │
                    │    Port 80 - External      │
                    └─────────────┬──────────────┘
                                  │
              ┌───────────────────┼───────────────────┐
              │                   │                   │
      ┌───────▼────────┐  ┌──────▼───────┐  ┌───────▼────────┐
      │  Web Instance  │  │ Web Instance │  │  Web Instance  │
      │   (Public)     │  │  (Public)    │  │   (Public)     │
      │   us-east-1a   │  │  us-east-1b  │  │   us-east-1a   │
      └───────┬────────┘  └──────┬───────┘  └───────┬────────┘
              │                   │                   │
              └───────────────────┼───────────────────┘
                                  │
                          ┌───────▼────────┐
                          │  NAT Gateway   │
                          └───────┬────────┘
                                  │
                    ┌─────────────▼──────────────┐
                    │  App Tier ALB (Internal)   │
                    │    Port 80 - Internal      │
                    └─────────────┬──────────────┘
                                  │
                    ┌─────────────┼─────────────┐
                    │             │             │
            ┌───────▼────────┐ ┌─▼──────────┐  │
            │  App Instance  │ │App Instance│  │
            │   (Private)    │ │ (Private)  │  │
            │   us-east-1a   │ │ us-east-1b │  │
            └───────┬────────┘ └─┬──────────┘  │
                    │             │             │
                    └─────────────┼─────────────┘
                                  │
                          ┌───────▼────────┐
                          │  RDS MySQL     │
                          │  Multi-AZ      │
                          │   (Private)    │
                          └────────────────┘
```

### Tier Breakdown:

**🌐 Web Tier (Public Subnets)**
- Application Load Balancer (internet-facing)
- Auto Scaling Group (2-4 instances)
- Apache web servers
- Direct internet access via Internet Gateway

**⚙️ App Tier (Private Subnets)**
- Internal Application Load Balancer
- Auto Scaling Group (2 instances)
- Application logic layer
- Internet access via NAT Gateway

**💾 Database Tier (Private Subnets)**
- RDS MySQL (Multi-AZ for high availability)
- Automated backups
- No direct internet access

---

## 🚀 What Gets Deployed

### Networking
- ✅ 1 VPC (10.0.0.0/16)
- ✅ 6 Subnets across 2 Availability Zones
  - 2 Public subnets (10.0.1.0/24, 10.0.2.0/24)
  - 2 Private app subnets (10.0.3.0/24, 10.0.4.0/24)
  - 2 Private DB subnets (10.0.5.0/24, 10.0.6.0/24)
- ✅ 1 Internet Gateway
- ✅ 1 NAT Gateway
- ✅ Route Tables (public & private)

### Compute
- ✅ 2 Launch Templates (web + app tier)
- ✅ 2 Auto Scaling Groups
  - Web tier: 2-4 instances
  - App tier: 2 instances
- ✅ 6 Security Groups (properly configured)

### Load Balancing
- ✅ 2 Application Load Balancers
  - Web tier (internet-facing)
  - App tier (internal)
- ✅ Target Groups with health checks
- ✅ Listeners on port 80

### Database
- ✅ RDS MySQL 5.7
- ✅ Multi-AZ deployment
- ✅ db.t3.micro instance
- ✅ Automated backups
- ✅ DB subnet group

### Security
- ✅ SSH key pair (auto-generated)
- ✅ Security groups with least privilege
- ✅ Private subnets for app/DB tiers

---

## ✅ Prerequisites

### Required
1. **AWS Account** - [Sign up here](https://aws.amazon.com/)
2. **AWS CLI configured** with credentials
3. **Terraform** installed (we'll help with this!)

### That's it! 🎉
No manual AWS resource creation needed - Terraform handles everything!

---

## ⚡ Quick Start

```powershell
# 1. Clone the repository
git clone https://github.com/nicobe20/3tier-terraform-project.git
cd 3tier-terraform-project

# 2. Initialize Terraform
terraform init

# 3. Review the plan
terraform plan -var-file="secret.tfvars"

# 4. Deploy!
terraform apply -var-file="secret.tfvars"

# 5. Get your application URL
terraform output web-server-dns
```

**Deployment time:** ~15-20 minutes

---

## 📁 Project Structure

```
3tier-terraform-project/
│
├── 📄 Terraform Configuration Files
│   ├── Provider.tf           # AWS provider configuration
│   ├── backend.tf            # State management (local)
│   ├── variables.tf          # Variable definitions
│   ├── terraform.tfvars      # Variable values
│   ├── secret.tfvars         # Database credentials (gitignored)
│   └── output.tf             # Output definitions
│
├── 🏗️ Infrastructure as Code
│   ├── networking.tf         # VPC, subnets, gateways, route tables
│   ├── compute.tf            # EC2, ASG, launch templates, security groups
│   ├── loadbalancer.tf       # ALBs, target groups, listeners
│   ├── database.tf           # RDS MySQL, DB security group
│   └── keypair.tf            # SSH key pair generation
│
├── 📜 Scripts & Configuration
│   └── user-data.sh          # EC2 startup script (Apache setup)
│
├── 📚 Documentation
│   └── README.md             # This file!
│
└── 🔒 Git Configuration
    └── .gitignore            # Excludes sensitive files
```

---

## ⚙️ Configuration

### 1. AWS Credentials Setup

**Option A: Using AWS CLI (Recommended)**
```powershell
aws configure
```
Enter your:
- Access Key ID
- Secret Access Key
- Default region: `us-east-1`
- Output format: `json`

**Option B: Environment Variables**
```powershell
$env:AWS_ACCESS_KEY_ID="your-access-key"
$env:AWS_SECRET_ACCESS_KEY="your-secret-key"
$env:AWS_DEFAULT_REGION="us-east-1"
```

### 2. Customize Variables (Optional)

Edit `terraform.tfvars` to customize:
```hcl
region-name    = "us-east-1"      # AWS region
vpc-cidr-block = "10.0.0.0/16"    # VPC CIDR
instance-type  = "t2.micro"        # EC2 instance type
# ... and more
```

Edit `secret.tfvars` for database credentials:
```hcl
db-username = "admin"
db-password = "YourSecurePassword123!"
```

**⚠️ Important:** Never commit `secret.tfvars` to version control!

---

## 🚀 Deployment Steps

### Step 1: Install Terraform
See the [Terraform Installation Guide](#terraform-installation) below.

### Step 2: Initialize
```powershell
terraform init
```
This downloads required providers and initializes the backend.

### Step 3: Validate
```powershell
terraform validate
```
Checks for syntax errors.

### Step 4: Format (Optional)
```powershell
terraform fmt
```
Auto-formats all `.tf` files.

### Step 5: Plan
```powershell
terraform plan -var-file="secret.tfvars"
```
Shows what will be created. Review carefully!

### Step 6: Apply
```powershell
terraform apply -var-file="secret.tfvars"
```
Type `yes` when prompted.

⏱️ **Wait 15-20 minutes** while Terraform creates your infrastructure.

---

## 🎯 After Deployment

### Access Your Application

```powershell
# Get the web tier load balancer URL
terraform output web-server-dns
```

Output example:
```
web-server-dns = "three-tier-alb-web-123456789.us-east-1.elb.amazonaws.com"
```

Open this URL in your browser! You'll see the Apache welcome page.

### SSH into Instances

The SSH key is automatically generated as `three-tier-key.pem`:

```powershell
# Get instance public IP from AWS Console
ssh -i three-tier-key.pem ubuntu@<instance-public-ip>
```

### View All Outputs

```powershell
terraform output
```

You'll see:
- Web server DNS
- App server DNS (internal)
- Database endpoint
- SSH key location
- SSH connection example

### Check Infrastructure State

```powershell
# View all resources
terraform show

# List all resources
terraform state list
```

---

## 💰 Cost Estimate

**Approximate monthly cost:** $65-75 USD

| Resource | Type | Quantity | Est. Cost |
|----------|------|----------|-----------|
| NAT Gateway | - | 1 | ~$32/month + data |
| ALB (Web) | Application | 1 | ~$16/month |
| ALB (App) | Application | 1 | ~$16/month |
| EC2 (Web) | t2.micro | 2-4 | Free tier eligible |
| EC2 (App) | t2.micro | 2 | Free tier eligible |
| RDS MySQL | db.t3.micro | 1 | Free tier eligible |

**💡 Cost Optimization Tips:**
- Use only during development/testing
- Destroy when not in use (`terraform destroy`)
- Free tier covers first 750 hours/month
- Consider removing Multi-AZ for RDS in dev

---

## 🔧 Troubleshooting

### Common Issues

#### 1. "Error creating key pair: duplicate key"
**Solution:** Delete existing key from AWS Console → EC2 → Key Pairs → Delete `three-tier-key`

#### 2. "UnauthorizedOperation"
**Solution:** AWS credentials lack permissions. Ensure IAM user has:
- AmazonEC2FullAccess
- AmazonVPCFullAccess
- AmazonRDSFullAccess
- ElasticLoadBalancingFullAccess

Or use Administrator access for simplicity.

#### 3. "InvalidAMIID.NotFound"
**Solution:** Update AMI ID in `terraform.tfvars`:

```powershell
# Find latest Ubuntu AMI for your region
aws ec2 describe-images \
  --owners 099720109477 \
  --filters "Name=name,Values=ubuntu/images/hvm-ssd/ubuntu-jammy-22.04*" \
  --query "Images | sort_by(@, &CreationDate) | [-1].ImageId" \
  --region us-east-1
```

#### 4. "Error creating DB instance: DBSubnetGroupNotFound"
**Solution:** This shouldn't happen with our setup, but if it does:
```powershell
terraform destroy -target=aws_db_instance.rds-db
terraform apply -var-file="secret.tfvars"
```

#### 5. Web page not loading
**Wait 5-10 minutes** - instances need time to:
- Launch
- Run user-data script
- Pass health checks
- Register with load balancer

---

## 🧹 Cleanup

### Destroy All Resources

```powershell
terraform destroy -var-file="secret.tfvars"
```

Type `yes` when prompted.

This will delete **everything** Terraform created:
- EC2 instances
- Load balancers
- RDS database
- NAT gateway
- VPC and all networking

**⏱️ Destruction time:** ~10-15 minutes

**💡 Tip:** The SSH key file (`three-tier-key.pem`) will remain on your local machine. Delete manually if needed.

---

## 📚 Additional Resources

- [Terraform AWS Provider Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/)
- [Terraform Best Practices](https://www.terraform-best-practices.com/)

---

## 🛠️ Terraform Installation

### Windows (PowerShell)

**Option 1: Using Chocolatey (Recommended)**
```powershell
# Install Chocolatey if not installed
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Install Terraform
choco install terraform -y

# Verify installation
terraform version
```

**Option 2: Manual Installation**
1. Download from [terraform.io/downloads](https://www.terraform.io/downloads)
2. Extract the `.zip` file
3. Move `terraform.exe` to a directory in your PATH (e.g., `C:\Windows\System32`)
4. Verify: `terraform version`

**Option 3: Using Winget**
```powershell
winget install --id=Hashicorp.Terraform -e
```

---

## 📝 License

This project is open source and available for educational purposes.

---

## 👤 Author

**nicobe20**
- GitHub: [@nicobe20](https://github.com/nicobe20)

---

## 🤝 Contributing

Contributions, issues, and feature requests are welcome!

---

**Happy Terraforming! 🚀**