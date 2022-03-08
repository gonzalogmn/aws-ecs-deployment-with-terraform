# aws-ecs-deployment-with-terraform

![](/utils/img/aws-ecs-deployment-with-terraform.drawio.png)


## Requisites

### Installations required

- [`docker`](https://docs.docker.com/engine/install/)
- [`aws`](https://docs.aws.amazon.com/es_es/cli/latest/userguide/cli-chap-install.html)
- [`tfenv`](https://github.com/tfutils/tfenv)
- [aws-nuke](https://github.com/rebuy-de/aws-nuke) (to be able to destroy all remaining resources after a `terraform destroy`)


### Create IAM user

- Sign in to the IAM console, and choose "Add User"
- Select the check box for AWS Management Console access, select "Custom Password", and type in your new password.
- On the Permissions page, either directly attach the `AdministratorAccess` policy or add the user to a group that already has this policy.
- Under the "Security Credentials" tab, you can then create access keys to authenticate against AWS service APIs.
- Download access keys.

### Configure aws profile

With downloaded access keys, create a new profile in your `~/.aws/credentials` file:

```
...

[admin-ecs-deployment-demo]
aws_access_key_id = <your_aws_access_key_id>
aws_secret_access_key = <your_aws_secret_access_key>
region = us-east-1

```

### Execute this **only once**! when creating project from zero

- Create `terraform/remote-state/terraform.tfvars` file with this content:

```
app_name        = "demo-api"
app_environment = "test"
```

- In `terraform/remote-state` folder, run:

```sh
terraform init
terraform apply
```

This will generate the required S3 backend to host Terraform state file, and the ECR repository to save our app Docker images. 


### Configure required variables

Create `terraform/terraform.tfvars` file with this content:

```
aws_default_region = "us-east-1"

availability_zones = ["us-east-1a", "us-east-1b"]
public_subnets     = ["10.10.100.0/24", "10.10.101.0/24"]
private_subnets    = ["10.10.0.0/24", "10.10.1.0/24"]

app_name        = "demo-api"
app_environment = "test"

ecr_repository = <ECR_REPOSITORY_ARN>  # for example 858334592091.dkr.ecr.us-east-1.amazonaws.com
```

### Configure `aws-nuke`

- Create `utils/aws-nuke-config.yml` with this content:

```yml
regions:
- us-east-1
- global

account-blocklist:
- "999999999999" # fake production

accounts:
  "<YOUR_ACCOUNT_ID>": 
    filters:
      IAMUser:
      - "<YOUR_USER>"
      IAMUserPolicyAttachment:
      - "<YOUR_USER> -> AdministratorAccess"
      IAMUserAccessKey:
      - "<YOUR_USER> -> <YOUR_ACCESS_KEY>"
      IAMLoginProfile:
      - "<YOUR_USER>"
```

## Start

```
make start
```

## Deploy

```
make deploy
```

## Cleaning up

```
cd terraform && terraform destroy
cd terraform/remote-state && terraform destroy

# To be able to delete all remaining resources
aws-nuke -c utils/aws-nuke-config.yml --profile admin-ecs-deployment-demo --no-dry-run
```

## References
- [https://dev.to/thnery/create-an-aws-ecs-cluster-using-terraform-g80](https://dev.to/thnery/create-an-aws-ecs-cluster-using-terraform-g80)
