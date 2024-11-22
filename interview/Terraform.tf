$ terraform plan vs terraform apply:
terraform plan shows proposed changes without applying them, helping to review what will change in the infrastructure.
terraform apply executes those changes, creating or updating resources.

$ Purpose of a Terraform provider:
Providers allow Terraform to interact with cloud platforms (e.g., AWS, GCP) by translating Terraform configurations into API calls. Common providers include AWS, Azure, and Kubernetes.

$terraform import brings existing resources into the state without creating new ones, useful when integrating with resources not originally managed by Terraform.

$ Managing sensitive information in the state file:
Sensitive information should be managed using secure backends like AWS S3 with encryption, avoiding plaintext storage and using tools like HashiCorp Vault for secrets.

$ Remote backends like S3 with DynamoDB for locking prevent conflicts and ensure consistent state. Collaborators can’t modify the state simultaneously, preventing overwrite conflicts.

$terraform taint:
Marks a resource for destruction and recreation on the next apply, useful for correcting corrupted or malfunctioning resources without altering other infrastructure.

$ Using tools like terraform validate and terraform plan for syntax and dependency checks, and Terratest or similar frameworks for integration testing before production deployment.

$ Managing S3 buckets with Terraform:
Configure aws_s3_bucket with versioning and lifecycle rules to manage data retention and costs. aws_s3_bucket_policy allows fine-grained access control.

terraform local:
In Terraform, locals are used to define and manage reusable expressions or values within a configuration. These local values are evaluated once per configuration, and their purpose is to improve readability, reduce repetition, and simplify complex expressions.

1. What is the purpose of the Terraform lock file?
Answer: The terraform.lock.hcl file ensures that Terraform uses the same version of provider plugins every time it runs, creating a consistent and predictable deployment experience. It records checksums and version details for providers to avoid unexpected changes caused by updates or different provider versions.
