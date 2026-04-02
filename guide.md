# Running Terraform for an AWS Pipeline in VSCode Terminal

## 1. Open the VSCode Terminal
Inside VSCode:

Go to View → Terminal

This opens an integrated shell (PowerShell, bash, zsh, etc.).

## 2. Navigate to Your Terraform Project Directory
If you just opened VSCode in the repo root, you may already be there.
Otherwise:
```bash
cd path/to/your/terraform/folder
```

Check your files:
```bash
ls
```

You should see something like:
```bash
main.tf
variables.tf
outputs.tf
modules/
```

## 3. Configure AWS Credentials (if not already configured)
Option A – Using AWS CLI
Run:
```bash
aws configure
```

Enter your:

- AWS Access Key ID
- AWS Secret Access Key
- AWS Region (e.g. eu-west-2)
- Output format (optional)

Option B – Using environment variables
Useful for pipelines:
```bash
export AWS_ACCESS_KEY_ID="xxxxx"
export AWS_SECRET_ACCESS_KEY="xxxxx"
export AWS_DEFAULT_REGION="eu-west-2"
```

## 4. Initialize Terraform
This downloads providers (like AWS) and sets up .terraform/.
```bash
terraform init
```

You should see:

✅ Provider plugins installed

✅ Backend configuration (if using S3 backend)

✅ Initialisation complete

## 5. Validate the Configuration
Check the syntax:
```bash
terraform validate
```
If something is wrong (e.g., missing variable), Terraform will tell you.

## 6. Format Your Terraform Code (Optional but Recommended)
Cleans up code formatting:
```bash
terraform fmt
```

## 7. Preview Changes (Terraform Plan)
This shows what Terraform will deploy:
```bash
terraform plan
```

If you have variables defined, use a .tfvars file:
```bash
terraform plan -var-file="dev.tfvars"
```

You should see something like:
Plan: 17 to add, 0 to change, 0 to destroy.


## 8. Apply the Terraform Plan (Deploy to AWS)
This actually deploys infrastructure:
```bash
terraform apply
```
You must type:
```bash
yes
```

—or skip prompts:
```bash
terraform apply -auto-approve
```
