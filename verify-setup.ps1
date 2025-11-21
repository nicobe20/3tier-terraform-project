#!/usr/bin/env pwsh
# Terraform & AWS Setup Verification Script

Write-Host "`n=== Terraform Installation Check ===" -ForegroundColor Cyan

# Check Terraform
$terraformPath = Get-Command terraform -ErrorAction SilentlyContinue
if ($terraformPath) {
    Write-Host "✅ Terraform is installed" -ForegroundColor Green
    $version = & terraform version -json | ConvertFrom-Json
    Write-Host "   Version: $($version.terraform_version)" -ForegroundColor Gray
} else {
    Write-Host "❌ Terraform not found. Please restart PowerShell and try again." -ForegroundColor Red
    Write-Host "   The PATH was updated during installation." -ForegroundColor Yellow
}

Write-Host "`n=== AWS Credentials Check ===" -ForegroundColor Cyan

# Check AWS CLI
$awsPath = Get-Command aws -ErrorAction SilentlyContinue
if ($awsPath) {
    Write-Host "✅ AWS CLI is installed" -ForegroundColor Green
    
    # Check credentials
    try {
        $identity = aws sts get-caller-identity 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ AWS credentials are configured" -ForegroundColor Green
            $identityJson = $identity | ConvertFrom-Json
            Write-Host "   Account: $($identityJson.Account)" -ForegroundColor Gray
            Write-Host "   User: $($identityJson.Arn)" -ForegroundColor Gray
        } else {
            Write-Host "⚠️  AWS credentials not configured" -ForegroundColor Yellow
            Write-Host "   Run: aws configure" -ForegroundColor Gray
        }
    } catch {
        Write-Host "⚠️  AWS credentials not configured" -ForegroundColor Yellow
        Write-Host "   Run: aws configure" -ForegroundColor Gray
    }
} else {
    Write-Host "⚠️  AWS CLI not installed (optional but recommended)" -ForegroundColor Yellow
    Write-Host "   Download from: https://aws.amazon.com/cli/" -ForegroundColor Gray
}

Write-Host "`n=== Project Files Check ===" -ForegroundColor Cyan

# Check required files
$requiredFiles = @(
    "Provider.tf",
    "backend.tf",
    "variables.tf",
    "terraform.tfvars",
    "secret.tfvars",
    "networking.tf",
    "compute.tf",
    "loadbalancer.tf",
    "database.tf",
    "keypair.tf",
    "output.tf"
)

$allPresent = $true
foreach ($file in $requiredFiles) {
    if (Test-Path $file) {
        Write-Host "✅ $file" -ForegroundColor Green
    } else {
        Write-Host "❌ $file (missing)" -ForegroundColor Red
        $allPresent = $false
    }
}

if ($allPresent) {
    Write-Host "`n✨ All project files are present!" -ForegroundColor Green
} else {
    Write-Host "`n⚠️  Some files are missing" -ForegroundColor Yellow
}

Write-Host "`n=== Next Steps ===" -ForegroundColor Cyan
Write-Host "1. If Terraform wasn't found, restart PowerShell" -ForegroundColor White
Write-Host "2. Configure AWS credentials: aws configure" -ForegroundColor White
Write-Host "3. Initialize Terraform: terraform init" -ForegroundColor White
Write-Host "4. Review the plan: terraform plan -var-file='secret.tfvars'" -ForegroundColor White
Write-Host "5. Deploy: terraform apply -var-file='secret.tfvars'" -ForegroundColor White
Write-Host ""
