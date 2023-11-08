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
