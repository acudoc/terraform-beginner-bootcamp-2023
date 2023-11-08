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

This is default file to load in tf variables in blunk

### auto.tfvars

### order of tf variables



