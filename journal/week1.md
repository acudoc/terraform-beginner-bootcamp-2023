# Terraform Beginner Bootcamp 2023 - Week 1

## Fixing Tags

[How to Delete Local and Remote Tags on Git](https://devconnected.com/how-to-delete-local-and-remote-tags-on-git/)

Locall delete a tag
```sh
git tag -d <tag_name>
```

Remotely delete tag

```sh
git push --delete origin tagname
```

Checkout the commit that you want to retag. Grab the sha from your Github history.

```sh
git checkout <SHA>
git tag M.M.P
git push --tags
git checkout main
```

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

- [AWS S3 Bucket Import](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#import)
- [tf Import](https://developer.hashicorp.com/terraform/cli/import/usage)

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

[Module Source Docs](https://developer.hashicorp.com/terraform/language/modules/sources#local-paths)

## Warning about using ChatGPT to write Terraform

ChatGPT was trained on older terraform documentation. Examples provided by ChatGPT were for older versions of terraform and some functions were deprecated. Its critical to check documentation of terraform and providers to fix issues.

## Working with Files in tf

### File exists function

`fileexists` is built in tf function to check existence of a file:

```tf
validation {
    condition = fileexists(var.index_html_filepath)
    error_message = "The provided path for index.html does not exist."
  }
```

### Filemd5

[tf docs](https://developer.hashicorp.com/terraform/language/functions/filemd5)

### Path Variable

In tf there is special variable called `path`, this allows local path reference:
- `path.module` = get the path for current module
- `path.root` = get the path for root module

[Special Path Variable](https://developer.hashicorp.com/terraform/language/expressions/references#filesystem-and-workspace-info)

```tf
resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = "index.html"
  source = ${path.root}/public/index.html
}
```

## Terraform Locals

Locals allows us to define local variables.
It can be very useful when we need transform data into another format and have referenced a varaible.

```tf
locals {
  s3_origin_id = "MyS3Origin"
}
```
[Local Values](https://developer.hashicorp.com/terraform/language/values/locals)

## Terraform Data Sources

This allows use to source data from cloud resources.

This is useful when we want to reference cloud resources without importing them.

```tf
data "aws_caller_identity" "current" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}
```
[Data Sources](https://developer.hashicorp.com/terraform/language/data-sources)

## Working with JSON

We use the jsonencode to create the json policy inline in the hcl.

```tf
> jsonencode({"hello"="world"})
{"hello":"world"}
```

[jsonencode](https://developer.hashicorp.com/terraform/language/functions/jsonencode)

### Changing the Lifecycle of Resources

[Meta Arguments Lifcycle](https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle)


## Terraform Data

Plain data values such as Local Values and Input Variables don't have any side-effects to plan against and so they aren't valid in replace_triggered_by. You can use terraform_data's behavior of planning an action each time input changes to indirectly use a plain value to trigger replacement.

https://developer.hashicorp.com/terraform/language/resources/terraform-data

## Provisioners

Provisioners allow you to execute commands on compute instances eg. a AWS CLI command.

They are not recommended for use by Hashicorp because Configuration Management tools such as Ansible are a better fit, but the functionality exists.

[Provisioners](https://developer.hashicorp.com/terraform/language/resources/provisioners/syntax)

### Local-exec

This will execute command on the machine running the terraform commands eg. plan apply

```tf
resource "aws_instance" "web" {
  # ...

  provisioner "local-exec" {
    command = "echo The server's IP address is ${self.private_ip}"
  }
}
```

https://developer.hashicorp.com/terraform/language/resources/provisioners/local-exec

### Remote-exec

This will execute commands on a machine which you target. You will need to provide credentials such as ssh to get into the machine.

```tf
resource "aws_instance" "web" {
  # ...

  # Establishes connection to be used by all
  # generic remote provisioners (i.e. file/remote-exec)
  connection {
    type     = "ssh"
    user     = "root"
    password = var.root_password
    host     = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "puppet apply",
      "consul join ${aws_instance.web.private_ip}",
    ]
  }
}
```
https://developer.hashicorp.com/terraform/language/resources/provisioners/remote-exec

## For Each Expressions

For each allows us to enumerate over complex data types

```sh
[for s in var.list : upper(s)]
```

This is mostly useful when you are creating multiples of a cloud resource and you want to reduce the amount of repetitive terraform code.

[For Each Expressions](https://developer.hashicorp.com/terraform/language/expressions/for)

### Unexpected Issue
I was not able to get code to run following along in class.
There was a prompt for assets_path each time I ran `tf.plan`

Finally, needed to add `assets_path = var.assets_path` in root level `main.tf`