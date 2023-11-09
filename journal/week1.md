# Terraform Beginner Bootcamp 2023 - Week 1

## Root Module Structure

The root structure:

```
PROJECT_ROOT
│
├── main.tf                #everything else
├── variables.tf           #stores structure of input variables
├── terraform.tfvars       #data of variables to load into tf project
├── providers.tf           #defined required providers and their configuration
├── outputs.tf             #stores our output
└── README.md              #required for root modules
```

[Standard Module Structure](https://developer.hashicorp.com/terraform/language/modules/develop/structure)

## Terraform Variables

[tf variable docs](https://developer.hashicorp.com/terraform/tutorials/configuration-language/variables)

### tf Cloud Variables

Variables can be set in two ways:
- Environment Variables - are normally set in Bash terminal eg. AWS credentials 
- Terraform Variables - are normally set in tfvars file eg. (`terraform.tfvars`)

Variables can be set to sensitive, so they are not visible

### Loading tf Input Variables

[tf input variable doc](https://developer.hashicorp.com/terraform/language/values/variables)

### var flag
The `-var` flag is used to set input variable or override a variable in the tfvars file: 

`terraform -var user_id="my_user_id"`

### var-file flag
For multiple variables, it is easier to specify their values in a variable definitions file (with a filename ending in either `.tfvars` or `.tfvars.json`) and then specify that file on the command line with `-var-file`:

`terraform apply -var-file="testing.tfvars"`

### terraform.tfvars

Allow us to manage variable assignments systematically in a file with the extension `.tfvars` or `.tfvars.json`

[Great Article about tfvars](https://spacelift.io/blog/terraform-tfvars)

### auto.tfvars

The `.auto.tfvars` get put at the end of a file name. `my-test.auto.tfvars`

### order of tf variables

Terraform loads variables in the following order:

-    A variable value file explicitly referenced using a "-var" flag.
-    A ".tfvars" file explicitly referenced using a "-var-file" flag.
-    A file with the ".auto.tfvars" extension.
-    A file called "terraform.tfvars".
-    An environment variable with the "TF_VAR_name" format.
-    The default value in the variable definition.

## Dealing with Configuration Drift

## What if we Lose our State File?

Most likely have to tear down all your cloud infrastructure manually.
Terraform import will work for some, but not all resources. Check terraform provider's
documentation to see what resources support import.

### Fix Missing Resources with Terraform Import

`terraform import aws_s3_bucket.bucket bucket-name`

[AWS S3 Bucket Import](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#import)
[tf Import](https://developer.hashicorp.com/terraform/cli/import/usage)

### Fix Manual Configuration 

If cloud resource is modified or deleted manually through ClickOps.
Running terraform plan will attempt to put our infrastructure back into expected state fixing Configuration Drift

## tf Modules

### tf Module Structure

Recommended to place modules in a `modules` directory when locally developing modules. But, name can be anything.

### Passing Input Variables

First pass variables into our module, then the module declares the variables in its own variables.tf

```tf
module "terrahouse_aws" {
  source = "./modules/terrahouse_aws"
  user_uuid = var.user_uuid
  bucket_name = var.bucket_name
}
```

### Modules Sources

Using the source we can import the module from various places eg:
- locally
- Github
- Terraform Registry

```tf
module "terrahouse_aws" {
  source = "./modules/terrahouse_aws"
}
```

[](https://developer.hashicorp.com/terraform/language/modules/sources#local-paths)