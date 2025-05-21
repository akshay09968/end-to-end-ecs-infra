# Terraform AWS Infrastructure Setup

## S3 Backend Configuration
- The S3 bucket and DynamoDB table for Terraform state locking must be created in the `ap-south-1` region.
- The `ap-south-2` region does not yet support Terraform's S3 backend.
- All other AWS resources will be created in the `ap-south-2` region.

## IAM Setup
```bash
terraform init
terraform plan
terraform apply --auto-approve
```

---

## VPC Setup
```bash
terraform workspace init --reconfigure

terraform workspace list

terraform workspace new dev
terraform workspace new prod

terraform workspace select dev
terraform plan --var-file="environment.tfvars"
terraform apply --auto-approve --var-file="environment.tfvars"

terraform workspace select prod
terraform plan --var-file="environment.tfvars"
terraform apply --auto-approve --var-file="environment.tfvars"
```

---

## ALB Setup
```bash
terraform workspace init --reconfigure

terraform workspace list

terraform workspace new dev
terraform workspace new prod

terraform workspace select dev
terraform plan --var-file="environment.tfvars"
terraform apply --auto-approve --var-file="environment.tfvars"

terraform workspace select prod
terraform plan --var-file="environment.tfvars"
terraform apply --auto-approve --var-file="environment.tfvars"
```

---

## ECS Setup
```bash
terraform workspace init --reconfigure

terraform workspace list

terraform workspace new dev
terraform workspace new prod

terraform workspace select dev
terraform plan --var-file="environment.tfvars"
terraform apply --auto-approve --var-file="environment.tfvars"

terraform workspace select prod
terraform plan --var-file="environment.tfvars"
terraform apply --auto-approve --var-file="environment.tfvars"

# Destroy ECS resources if needed
terraform destroy --auto-approve --var-file="environment.tfvars"
```

---

### Notes:
- Ensure Terraform is properly initialized before running any workspace-specific commands.
- Always verify the selected workspace before applying changes.
- The S3 backend must be manually created in `ap-south-1` before running Terraform.
- Use `environment.tfvars` to configure environment-specific variables.

---

### Author:
- **Akshay**

Happy Terraforming! 🚀
